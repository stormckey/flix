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

import ca.uwaterloo.flix.api.lsp.provider.completion.Completion.ImportCompletion
import ca.uwaterloo.flix.language.errors.ResolutionError
import ca.uwaterloo.flix.util.ClassList

object ImportCompleter {

  def getCompletions(err: ResolutionError.UndefinedJvmClass): Iterable[ImportCompletion] = {
//    val path = err.name.split('.').toList
    // Get completions for if we are currently typing the next package/class and if we have just finished typing a package
//    javaClassCompletionsFromPrefix(path)(root) ++ javaClassCompletionsFromPrefix(path.dropRight(1))(root)
    javaClassCompletionsFromPrefix(err.name)
  }

  /**
    * Gets completions from a java path prefix
    */
  private def javaClassCompletionsFromPrefix(prefix: String): Iterable[ImportCompletion] = {
    ClassList.TheMap.m.keys.filter(_.startsWith(prefix)).flatMap { className =>
      val paths = ClassList.TheMap.get(className).get
      paths.map(ImportCompletion(className, _))
    }
  }
}
