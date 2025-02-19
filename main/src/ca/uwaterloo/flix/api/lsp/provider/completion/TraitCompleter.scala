/*
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

import ca.uwaterloo.flix.api.lsp.provider.completion.Completion.TraitCompletion
import ca.uwaterloo.flix.language.ast.NamedAst.Declaration.Trait
import ca.uwaterloo.flix.language.ast.{Name, TypedAst}
import ca.uwaterloo.flix.language.ast.shared.{AnchorPosition, LocalScope, Resolution}
import ca.uwaterloo.flix.language.errors.ResolutionError

object TraitCompleter {

  /**
   * Returns a List of Completion for traits.
   * Whether the returned completions are qualified is based on whether the name in the error is qualified.
   * When providing completions for unqualified enums that is not in scope, we will also automatically use the enum.
   */
  def getCompletions(err: ResolutionError.UndefinedTrait)(implicit root: TypedAst.Root): Iterable[Completion] = {
    getCompletions(err.qn.loc.source.name, err.ap, err.env, err.qn)
  }

  private def getCompletions(uri: String, ap: AnchorPosition, env: LocalScope, qn: Name.QName)(implicit root: TypedAst.Root): Iterable[Completion] = {
    if (qn.namespace.nonEmpty)
      root.traits.values.collect{
        case trt if matchesTrait(trt, qn, uri, qualified = true) =>
          TraitCompletion(trt, ap, qualified = true, inScope = true)
      }
    else
      root.traits.values.collect({
        case trt if matchesTrait(trt, qn, uri, qualified = false) =>
          TraitCompletion(trt, ap, qualified = false, inScope = inScope(trt, env))
      })
  }

  /**
   * Checks if the definition is in scope.
   * If we can find the definition in the scope or the definition is in the root namespace, it is in scope.
   */
  private def inScope(struct: TypedAst.Trait, scope: LocalScope): Boolean = {
    val thisName = struct.sym.toString
    val isResolved = scope.m.values.exists(_.exists {
      case Resolution.Declaration(Trait(_, _, _, thatName, _, _, _, _, _, _)) => thisName == thatName.toString
      case _ => false
    })
    val isRoot = struct.sym.namespace.isEmpty
    isRoot || isResolved
  }

  /**
   * Checks if the definition matches the QName.
   * Names should match and the definition should be available.
   */
  private def matchesTrait(struct: TypedAst.Trait, qn: Name.QName, uri: String, qualified: Boolean): Boolean = {
    val isPublic = struct.mod.isPublic && !struct.ann.isInternal
    val isInFile = struct.sym.loc.source.name == uri
    val isMatch = if (qualified)
      CompletionUtils.matchesQualifiedName(struct.sym.namespace, struct.sym.name, qn)
    else
      CompletionUtils.fuzzyMatch(qn.ident.name, struct.sym.name)
    isMatch && (isPublic || isInFile)
  }
}
