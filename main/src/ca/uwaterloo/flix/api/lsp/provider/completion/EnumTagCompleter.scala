/*
 * Copyright 2023 Lukas Rønn
 * Copyright 2025 Chenhao Gao
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

import ca.uwaterloo.flix.api.lsp.Range
import ca.uwaterloo.flix.api.lsp.provider.completion.Completion.EnumTagCompletion
import ca.uwaterloo.flix.language.ast.NamedAst.Declaration.{Case, Enum, Namespace}
import ca.uwaterloo.flix.language.ast.shared.{AnchorPosition, LocalScope, Resolution}
import ca.uwaterloo.flix.language.ast.{Name, Symbol, TypedAst}

object EnumTagCompleter {
  /**
    * Returns a List of Completion for Tag for UndefinedName.
    */
  def getCompletions(qn: Name.QName, range: Range, ap: AnchorPosition, env: LocalScope)(implicit root: TypedAst.Root): Iterable[Completion] = {
    if (qn.namespace.nonEmpty)
        fullyQualifiedCompletion(qn, range, ap) ++ partiallyQualifiedCompletions(qn, range, ap, env)
    else
      root.enums.values.flatMap(enm =>
        enm.cases.values.collect{
          case tag if CompletionUtils.isAvailable(enm) && CompletionUtils.matchesName(tag.sym, qn, qualified = false) =>
            EnumTagCompletion(tag, "", range, ap, qualified = false, inScope = inScope(tag, env))
        }
      )
  }

  /**
    * Returns a List of Completion for Tag for fully qualified names.
    *
    * We assume the user is trying to type a fully qualified name and will only match against fully qualified names.
    */
  private def fullyQualifiedCompletion(qn: Name.QName, range: Range, ap: AnchorPosition)(implicit root: TypedAst.Root): Iterable[Completion] = {
    root.enums.values.flatMap(enm =>
      enm.cases.values.collect{
        case tag if CompletionUtils.isAvailable(enm) && CompletionUtils.matchesName(tag.sym, qn, qualified = true) =>
          EnumTagCompletion(tag, "", range,  ap, qualified = true, inScope = true)
      }
    )
  }

  /**
    * Returns a List of Completion for Tag for partially qualified names.
    *
    * Example:
    *   - If `Foo.Bar.Color.Red` is fully qualified, then `Color.Red` is partially qualified
    *
    * We need to first find the fully qualified namespace by looking up the local environment, then use it to provide completions.
    */
  private def partiallyQualifiedCompletions(qn: Name.QName, range: Range,ap: AnchorPosition, env: LocalScope)(implicit root: TypedAst.Root): Iterable[Completion] = {
    val fullyQualifiedNamespaceHead = env.resolve(qn.namespace.idents.head.name) match {
      case Some(Resolution.Declaration(Enum(_, _, _, sym, _, _, _, _))) => sym.toString
      case Some(Resolution.Declaration(Namespace(name, _, _, _))) => name.toString
      case _ => return Nil
    }
    val namespaceTail = qn.namespace.idents.tail.map(_.name).mkString(".")
    val fullyQualifiedEnum = if (namespaceTail.isEmpty) fullyQualifiedNamespaceHead else s"$fullyQualifiedNamespaceHead.$namespaceTail"
    for {
      enm <- root.enums.get(Symbol.mkEnumSym(fullyQualifiedEnum)).toList
      tag <- enm.cases.values
      if CompletionUtils.isAvailable(enm) && CompletionUtils.matchesName(tag.sym, qn, qualified = false)
    } yield EnumTagCompletion(tag, qn.namespace.toString, range, ap, qualified = true, inScope = true)
  }

  private def inScope(tag: TypedAst.Case, scope: LocalScope): Boolean = {
    val thisName = tag.sym.toString
    val isResolved = scope.m.values.exists(_.exists {
      case Resolution.Declaration(Case(thatName, _, _)) => thisName == thatName.toString
      case _ => false
    })
    val isRoot = tag.sym.namespace.isEmpty
    isRoot || isResolved
  }

}
