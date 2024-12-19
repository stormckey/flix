/*
 * Copyright 2022 Paul Butcher, Lukas Rønn
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
package ca.uwaterloo.flix.api.lsp.provider.completion

import ca.uwaterloo.flix.api.lsp.provider.completion.Completion.DefCompletion
import ca.uwaterloo.flix.api.lsp.provider.completion.CompletionUtils.fuzzyMatch
import ca.uwaterloo.flix.language.ast.Name.QName
import ca.uwaterloo.flix.language.ast.NamedAst.Declaration.Def
import ca.uwaterloo.flix.language.ast.TypedAst
import ca.uwaterloo.flix.language.ast.shared.{LocalScope, Resolution}
import ca.uwaterloo.flix.language.errors.ResolutionError

object DefCompleter {
  def getCompletions(err: ResolutionError.UndefinedName)(implicit root: TypedAst.Root): Iterable[Completion] ={
    if (err.qn.namespace.idents.nonEmpty)
      root.defs.values.collect{
        case decl if matchesDef(decl, err.qn, err.loc.source.name, qualified = true)
        => DefCompletion(decl, err.ap, qualified = true, inScope = true)
      }
    else
      root.defs.values.collect{
        case decl if matchesDef(decl, err.qn, err.loc.source.name, qualified = false)
        => DefCompletion(decl, err.ap, qualified = false, inScope = inScope(decl, err.env))
      }
  }

  private def inScope(decl: TypedAst.Def, scope: LocalScope): Boolean = {
    val thisName = decl.sym.toString
    val isResolved = scope.m.values.exists(_.exists {
      case Resolution.Declaration(Def(thatName, _, _, _)) => thisName == thatName.toString
      case _ => false
    })
    val isRoot = decl.sym.namespace.isEmpty
    isRoot || isResolved
  }

  private def matchesDef(decl: TypedAst.Def, qn: QName, uri: String, qualified: Boolean): Boolean = {
    val isPublic = decl.spec.mod.isPublic && !decl.spec.ann.isInternal
    val isInFile = decl.sym.loc.source.name == uri
    val isMatch = if (qualified)
      decl.sym.toString.startsWith(qn.toString)
    else
      fuzzyMatch(qn.ident.name, decl.sym.name)
    isMatch && (isPublic || isInFile)
  }
}
