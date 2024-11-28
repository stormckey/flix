/*
 * Copyright 2024 Chenhao Gao
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

import ca.uwaterloo.flix.language.errors.ResolutionError
import ca.uwaterloo.flix.language.ast.shared.{Resolution, LocalScope}

/**
  * Provides completions for items in local scope, including:
  *   - Resolution.Declaration: functions, structs, enums, etc.
  *   - Resolution.JavaClass: java classes.
  *   - Resolution.Var: local variables, arguments.
  *   - Resolution.LocalDef: local definitions.
  */
object LocalScopeCompleter {
  /**
    * Returns a list of completions for UndefinedName.
    * We will provide all sorts of completions except for Resolution.TypeVar
    */
  def getCompletions(err: ResolutionError.UndefinedName): Iterable[Completion] =
    err.env.env.m.foldLeft((List.empty[Completion])){case (acc, (name, resolutions)) =>
      acc ++ mkDeclarationCompletion(name, resolutions) ++ mkJavaClassCompletion(name, resolutions) ++ mkVarCompletion(name, resolutions) ++ mkLocalDefCompletion(name, resolutions)
    }

  /**
    * Returns a list of completions for UndefinedType.
    * We will provide completions for Resolution.Declaration and Resolution.JavaClass
    */
  def getCompletions(err: ResolutionError.UndefinedType): Iterable[Completion] =
    err.env.env.m.foldLeft((List.empty[Completion])){case (acc, (name, resolutions)) =>
       acc ++ mkDeclarationCompletion(name, resolutions) ++ mkJavaClassCompletion(name, resolutions)
    }

  /**
    * Tries to create a DeclarationCompletion for the given name and resolutions.
    */
  private def mkDeclarationCompletion(k: String, v: List[Resolution]): Iterable[Completion] =
    if (v.exists{
      case Resolution.Declaration(_) => true
      case _ => false
    }) Completion.LocalDeclarationCompletion(k) :: Nil else Nil

  /**
    * Tries to create a JavaClassCompletion for the given name and resolutions.
    */
  private def mkJavaClassCompletion(k: String, v: List[Resolution]): Iterable[Completion] =
    if (v.exists{
      case Resolution.JavaClass(_) => true
      case _ => false
    }) Completion.LocalJavaClassCompletion(k) :: Nil else Nil

  /**
    * Tries to create a VarCompletion for the given name and resolutions.
    */
  private def mkVarCompletion(k: String, v: List[Resolution]): Iterable[Completion] = {
    if (v.exists{
      case Resolution.Var(_) => true
      case _ => false
    }) Completion.LocalVarCompletion(k) :: Nil else Nil
  }

  /**
    * Tries to create a LocalDefCompletion for the given name and resolutions.
    */
  private def mkLocalDefCompletion(k: String, v: List[Resolution]): Iterable[Completion] =
    v.collect{ case Resolution.LocalDef(sym, fparams) => (sym, fparams)}.map(Completion.LocalDefCompletion.tupled)

}