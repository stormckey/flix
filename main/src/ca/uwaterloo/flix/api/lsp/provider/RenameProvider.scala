/*
 * Copyright 2020 Magnus Madsen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ca.uwaterloo.flix.api.lsp.provider

import ca.uwaterloo.flix.api.lsp.{Entity, Index, Position, Range, ResponseStatus, TextEdit, WorkspaceEdit}
import ca.uwaterloo.flix.language.ast.TypedAst.{Binder, Pattern, Root}
import ca.uwaterloo.flix.language.ast.shared.SymUse.CaseSymUse
import ca.uwaterloo.flix.language.ast.{Name, SourceLocation, Symbol, Type, TypeConstructor}
import org.json4s.JsonAST.JObject
import org.json4s.JsonDSL.*

object RenameProvider {

  /**
    * Processes a rename request.
    */
  def processRename(newName: String, uri: String, pos: Position)(implicit index: Index): JObject = {
    index.query(uri, pos) match {
      case None => mkNotFound(uri, pos)

      case Some(entity) => entity match {

        case Entity.Case(caze) => renameCase(caze.sym, newName)

        case Entity.StructField(field) => renameStructField(field.sym, newName)

        case Entity.Def(defn) => renameDef(defn.sym, newName)

        case Entity.TypeAlias(alias) => renameTypeAlias(alias.sym, newName)

        case Entity.VarUse(sym, _, _) => renameVar(sym, newName)

        case Entity.DefUse(sym, _, _) => renameDef(sym, newName)

        case Entity.CaseUse(sym, _, _) => renameCase(sym, newName)

        case Entity.StructFieldUse(sym, _, _) => renameStructField(sym, newName)

        case Entity.Exp(_) => mkNotFound(uri, pos)

        case Entity.Label(label) => renameLabel(label, newName)

        case Entity.Pattern(pat) => pat match {
          case Pattern.Var(Binder(sym, _), _, _) => renameVar(sym, newName)
          case Pattern.Tag(CaseSymUse(sym, _), _, _, _) => renameCase(sym, newName)
          case _ => mkNotFound(uri, pos)
        }

        case Entity.Pred(pred, _) => renamePred(pred, newName)

        case Entity.FormalParam(fparam) => renameVar(fparam.bnd.sym, newName)

        case Entity.LocalVar(sym, _) => renameVar(sym, newName)

        case Entity.Type(t) => t match {
          case Type.Cst(tc, _) => tc match {
            case TypeConstructor.RecordRowExtend(label) => renameLabel(label, newName)
            case TypeConstructor.SchemaRowExtend(pred) => renamePred(pred, newName)
            case _ => mkNotFound(uri, pos)
          }
          case Type.Var(sym, _) => renameTypeVar(sym, newName)
          case _ => mkNotFound(uri, pos)
        }

        case Entity.Trait(_) => mkNotFound(uri, pos)
        case Entity.AssocType(_) => mkNotFound(uri, pos)
        case Entity.Effect(_) => mkNotFound(uri, pos)
        case Entity.Enum(_) => mkNotFound(uri, pos)
        case Entity.Struct(_) => mkNotFound(uri, pos)
        case Entity.Op(_) => mkNotFound(uri, pos)
        case Entity.OpUse(_, _, _) => mkNotFound(uri, pos)
        case Entity.Sig(_) => mkNotFound(uri, pos)
        case Entity.SigUse(_, _, _) => mkNotFound(uri, pos)
        case Entity.TypeVar(_) => mkNotFound(uri, pos)
      }
    }

  }

  /**
    * Constructs the JSON response for renaming all `occurences` to `newName`.
    *
    * NB: The occurrences must *NOT* overlap nor be repeated. Hence they are a set.
    */
  private def rename(newName: String, occurrences: Set[SourceLocation]): JObject = {
    // Convert the set of occurrences to a sorted list.
    val targets = occurrences.toList.sorted

    // Group by URI.
    val groupedByUri = targets.groupBy(_.source.name)

    // Construct text edits.
    val textEdits = groupedByUri map {
      case (uri, locs) => uri -> locs.map(loc => TextEdit(Range.from(loc), newName))
    }

    // Assemble the workspace edit.
    val workspaceEdit = WorkspaceEdit(textEdits)

    // Construct the JSON result.
    ("status" -> ResponseStatus.Success) ~ ("result" -> workspaceEdit.toJSON)
  }

  private def renameDef(sym: Symbol.DefnSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  private def renameEnum(sym: Symbol.EnumSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  private def renameTypeAlias(sym: Symbol.TypeAliasSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  private def renameLabel(label: Name.Label, newName: String)(implicit index: Index): JObject = {
    val defs = index.defsOf(label)
    val uses = index.usesOf(label)
    rename(newName, defs ++ uses)
  }

  private def renamePred(pred: Name.Pred, newName: String)(implicit index: Index): JObject = {
    val defs = index.defsOf(pred)
    val uses = index.usesOf(pred)
    rename(newName, defs ++ uses)
  }

  private def renameCase(sym: Symbol.CaseSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  private def renameStructField(sym: Symbol.StructFieldSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  private def renameTypeVar(sym: Symbol.KindedTypeVarSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  private def renameVar(sym: Symbol.VarSym, newName: String)(implicit index: Index): JObject = {
    val defn = sym.loc
    val uses = index.usesOf(sym)
    rename(newName, uses + defn)
  }

  /**
    * Returns a reply indicating that nothing was found at the `uri` and `pos`.
    */
  private def mkNotFound(uri: String, pos: Position): JObject =
    ("status" -> ResponseStatus.InvalidRequest) ~ ("message" -> s"Nothing found in '$uri' at '$pos'.")

}
