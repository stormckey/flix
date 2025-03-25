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

package ca.uwaterloo.flix.api.lsp

import ca.uwaterloo.flix.api.Flix
import ca.uwaterloo.flix.api.lsp.acceptors.InsideAcceptor
import ca.uwaterloo.flix.api.lsp.consumers.StackConsumer
import ca.uwaterloo.flix.language.ast.TypedAst.Root

object LspUtil {
  /**
    * Returns the stack of AST nodes that contains the given position.
    *
    * The stack is constructed from a visitor with an InsideAcceptor.
    *
    * Given that:
    * - We have to visit an AST node's parent before visiting the node itself
    * - If the given position is contained by an AST node, it will also be contained by the node's parent
    *
    * So the stack actually contains a path from the leaf node that contains the given position to the root node, with the leaf node at the top of the stack.
    */
  def getStack(uri: String, pos: Position)(implicit root: Root, flix: Flix): List[AnyRef] = {
    val stack = StackConsumer()

    if (pos.character >= 2) {
      val leftPos = Position(pos.line, pos.character - 1)
      Visitor.visitRoot(root, stack, InsideAcceptor(uri, leftPos))
    }

    stack.getStack
  }
}
