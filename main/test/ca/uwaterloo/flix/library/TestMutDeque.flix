/*
 * Copyright 2021 Jakob Schneider Villumsen
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

mod TestMutDeque {

    /////////////////////////////////////////////////////////////////////////////
    // emptyWithCapacity                                                       //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def emptyWithCapacity01(): Bool = region rc {
        let l: MutDeque[Int32, rc] = MutDeque.emptyWithCapacity(rc, 10);
        MutDeque.toString(l) == "MutDeque#{}"
    }

    @test
    def emptyWithCapacity02(): Bool = region rc {
        let l: MutDeque[Int32, rc] = MutDeque.emptyWithCapacity(rc, -1);
        MutDeque.toString(l) == "MutDeque#{}"
    }

    @test
    def emptyWithCapacity03(): Bool = region rc {
        let l: MutDeque[Int32, rc] = MutDeque.emptyWithCapacity(rc, 0);
        MutDeque.pushBack(5, l);
        MutDeque.pushBack(4, l);
        MutDeque.toString(l) == "MutDeque#{5, 4}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // toString                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toString01(): Bool = region rc {
        let d: MutDeque[Int32, rc] = MutDeque.empty(rc);
        MutDeque.toString(d) == "MutDeque#{}"
    }

    @test
    def toString02(): Bool = region rc {
        let d: MutDeque[Int32, rc] = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.toString(d) == "MutDeque#{1}"
    }

    @test
    def toString03(): Bool = region rc {
        let d: MutDeque[Int32, rc] = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushBack(4, d);
        MutDeque.pushBack(5, d);
        MutDeque.toString(d) == "MutDeque#{1, 2, 3, 4, 5}"
    }

    /////////////////////////////////////////////////////////////////////////////
    // size                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def size01(): Bool = region rc {
        MutDeque.size(MutDeque.empty(rc)) == 0
    }

    @test
    def size02(): Bool = region rc {
        let d = MutDeque.empty(rc);

        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);

        MutDeque.size(d) == 4
    }

    @test
    def size03(): Bool = region rc {
        let d = MutDeque.empty(rc);

        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);

        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(1, d);

        MutDeque.size(d) == 8
    }

    @test
    def size04(): Bool = region rc {
        let d = MutDeque.empty(rc);

        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);

        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);

        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);

        MutDeque.size(d) == 11
    }

    @test
    def size05(): Bool = region rc {
        let d = MutDeque.empty(rc);

        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);

        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);

        MutDeque.size(d) == 2

    }

    @test
    def size06(): Bool = region rc {
        let d = MutDeque.empty(rc);

        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);

        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);

        MutDeque.size(d) == 0
    }

    @test
    def size07(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        discard MutDeque.popBack(d);
        MutDeque.size(d) == 0
    }

    @test
    def size08(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        discard MutDeque.popFront(d);
        MutDeque.size(d) == 0
    }


    /////////////////////////////////////////////////////////////////////////////
    // isEmpty                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def isEmpty01(): Bool = region rc {
        MutDeque.isEmpty(MutDeque.empty(rc))
    }

    @test
    def isEmpty02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        not (MutDeque.isEmpty(d))
    }

    @test
    def isEmpty03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        discard MutDeque.popBack(d);
        MutDeque.isEmpty(d)
    }

    @test
    def isEmpty04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        not (MutDeque.isEmpty(d))
    }

    @test
    def isEmpty05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        discard MutDeque.popFront(d);
        MutDeque.isEmpty(d)
    }


    /////////////////////////////////////////////////////////////////////////////
    // nonEmpty                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def nonEmpty01(): Bool = region rc {
        not (MutDeque.nonEmpty(MutDeque.empty(rc)))
    }

    @test
    def nonEmpty02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.nonEmpty(d)
    }

    @test
    def nonEmpty03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        discard MutDeque.popBack(d);
        not (MutDeque.nonEmpty(d))
    }

    @test
    def nonEmpty04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.nonEmpty(d)
    }

    @test
    def nonEmpty05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        discard MutDeque.popFront(d);
        not (MutDeque.nonEmpty(d))
    }


    /////////////////////////////////////////////////////////////////////////////
    // popFront                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def popFront01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.popFront(d) == (None: Option[Int32])
    }

    @test
    def popFront02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.popFront(d) == Some(1)
    }

    @test
    def popFront03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(2, d);
        MutDeque.pushFront(3, d);
        MutDeque.popFront(d) == Some(3)     and
            MutDeque.popFront(d) == Some(2) and
            MutDeque.popFront(d) == Some(1) and
            MutDeque.popFront(d) == None
    }

    @test
    def popFront04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.popFront(d) == Some(1)     and
            MutDeque.popFront(d) == Some(2) and
            MutDeque.popFront(d) == Some(3) and
            MutDeque.popFront(d) == None
    }

    @test
    def popFront05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.popFront(d) == Some(1)     and
            MutDeque.popFront(d) == Some(2) and
            MutDeque.popFront(d) == None
    }

    @test
    def popFront06(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushFront(2, d);
        MutDeque.popFront(d) == Some(2)     and
            MutDeque.popFront(d) == Some(1) and
            MutDeque.popFront(d) == None
    }


    /////////////////////////////////////////////////////////////////////////////
    // popBack                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def popBack01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.popBack(d) == (None: Option[Int32])
    }

    @test
    def popBack02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.popBack(d) == Some(1)
    }

    @test
    def popBack03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.popBack(d) == Some(3)     and
            MutDeque.popBack(d) == Some(2) and
            MutDeque.popBack(d) == Some(1) and
            MutDeque.popBack(d) == None
    }

    @test
    def popBack04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(2, d);
        MutDeque.pushFront(3, d);
        MutDeque.popBack(d) == Some(1)     and
            MutDeque.popBack(d) == Some(2) and
            MutDeque.popBack(d) == Some(3) and
            MutDeque.popBack(d) == None
    }

    @test
    def popBack05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushFront(2, d);
        MutDeque.popBack(d) == Some(1)     and
            MutDeque.popBack(d) == Some(2) and
            MutDeque.popBack(d) == None
    }

    @test
    def popBack06(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.popBack(d) == Some(2)     and
            MutDeque.popBack(d) == Some(1) and
            MutDeque.popBack(d) == None
    }


    /////////////////////////////////////////////////////////////////////////////
    // pushFrontPushBack (expansion)                                           //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def pushFrontPushBack01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(2, d);
        // [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]

        MutDeque.popBack(d) == Some(2) and
        MutDeque.popFront(d) == Some(1) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(2) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == Some(1) and
        MutDeque.popBack(d) == None and
        MutDeque.popFront(d) == None
    }


    /////////////////////////////////////////////////////////////////////////////
    // peekFront                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def peekFront01(): Bool = region rc {
        let d = (MutDeque.empty(rc): MutDeque[Int32, rc]);
        MutDeque.peekFront(d) == None
    }

    @test
    def peekFront02(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        MutDeque.peekFront(d) == Some(1)
    }

    @test
    def peekFront03(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        MutDeque.peekFront(d) == Some(1) and
        MutDeque.peekFront(d) == Some(1) and
        MutDeque.peekFront(d) == Some(1)
    }

    @test
    def peekFront04(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);
        MutDeque.peekFront(d) == Some(3)
    }

    @test
    def peekFront05(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popFront(d);
        discard MutDeque.popBack(d);
        MutDeque.peekFront(d) == Some(2)
    }

    @test
    def peekFront06(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);
        discard MutDeque.popFront(d);
        MutDeque.peekFront(d) == None
    }


    /////////////////////////////////////////////////////////////////////////////
    // peekBack                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def peekBack01(): Bool = region rc {
        let d = (MutDeque.empty(rc): MutDeque[Int32, rc]);
        MutDeque.peekBack(d) == None
    }

    @test
    def peekBack02(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        MutDeque.peekBack(d) == Some(3)
    }

    @test
    def peekBack03(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        MutDeque.peekBack(d) == Some(3) and
        MutDeque.peekBack(d) == Some(3) and
        MutDeque.peekBack(d) == Some(3)
    }

    @test
    def peekBack04(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popBack(d);
        discard MutDeque.popBack(d);
        MutDeque.peekBack(d) == Some(1)
    }

    @test
    def peekBack05(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popBack(d);
        discard MutDeque.popFront(d);
        MutDeque.peekBack(d) == Some(2)
    }

    @test
    def peekBack06(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popBack(d);
        discard MutDeque.popBack(d);
        discard MutDeque.popBack(d);
        MutDeque.peekBack(d) == None
    }


    /////////////////////////////////////////////////////////////////////////////
    // sameElements                                                            //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sameElements01(): Bool = region rc {
        let d1 = (MutDeque.empty(rc): MutDeque[Int32, _]);
        let d2 = (MutDeque.empty(rc): MutDeque[Int32, _]);
        MutDeque.sameElements(d1, d2)
    }

    @test
    def sameElements02(): Bool = region rc {
        let d1 = MutDeque.empty(rc);
        MutDeque.pushBack(1, d1);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushFront(1, d2);

        MutDeque.sameElements(d1, d2)
    }

    @test
    def sameElements03(): Bool = region rc {
        let d1 = MutDeque.empty(rc);
        MutDeque.pushBack(1, d1);
        MutDeque.pushBack(2, d1);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushFront(1, d2);
        MutDeque.pushFront(2, d2);

        not MutDeque.sameElements(d1, d2)
    }

    @test
    def sameElements04(): Bool = region rc {
        let d1 = MutDeque.empty(rc);
        MutDeque.pushBack("a", d1);
        MutDeque.pushBack("b", d1);
        MutDeque.pushBack("c", d1);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushFront("b", d2);
        MutDeque.pushBack("c", d2);
        MutDeque.pushFront("a", d2);

        MutDeque.sameElements(d1, d2)
    }

    @test
    def sameElements05(): Bool = region rc {
        let d1 = MutDeque.empty(rc);
        MutDeque.pushBack("a", d1);
        MutDeque.pushBack("b", d1);
        MutDeque.pushBack("c", d1);

        let d2 = MutDeque.empty(rc);
        MutDeque.pushFront("a", d2);
        MutDeque.pushFront("b", d2);
        MutDeque.pushBack("c", d2);

        not MutDeque.sameElements(d1, d2)
    }


    /////////////////////////////////////////////////////////////////////////////
    // sum                                                                     //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sum01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.sum(d) == 0
    }

    @test
    def sum02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.sum(d) == 1
    }

    @test
    def sum03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.sum(d) == 6
    }

    @test
    def sum04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushBack(-3, d);
        MutDeque.sum(d) == 3
    }

    @test
    def sum05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushFront(-3, d);
        MutDeque.sum(d) == 3
    }

    @test
    def sum06(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(-1, d);
        MutDeque.pushBack(-2, d);
        MutDeque.pushFront(-3, d);
        MutDeque.pushFront(-4, d);
        MutDeque.sum(d) == -10
    }

    @test
    def sum07(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(10, d);
        MutDeque.pushBack(-10, d);
        MutDeque.sum(d) == 0
    }


    /////////////////////////////////////////////////////////////////////////////
    // sumWith                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def sumWith01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.sumWith(x -> x + 1, d) == 0
    }

    @test
    def sumWith02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.sumWith(x -> x + 1, d) == 2
    }

    @test
    def sumWith03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.sumWith(x -> x + 1, d) == 9
    }

    @test
    def sumWith04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushBack(-3, d);
        MutDeque.sumWith(x -> x + 1, d) == 7
    }

    @test
    def sumWith05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushFront(-3, d);
        MutDeque.sumWith(x -> x + 1, d) == 7
    }

    @test
    def sumWith06(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(-1, d);
        MutDeque.pushBack(-2, d);
        MutDeque.pushFront(-3, d);
        MutDeque.pushFront(-4, d);
        MutDeque.sumWith(x -> x + 1, d) == -6
    }

    @test
    def sumWith07(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(10, d);
        MutDeque.pushBack(-10, d);
        MutDeque.sumWith(x -> x + 1, d) == 2
    }


    /////////////////////////////////////////////////////////////////////////////
    // foldLeft                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldLeft01(): Bool = region rc {
        MutDeque.foldLeft((i, e) -> (i - e) * (e `Int32.remainder` 2 + 1), 100, MutDeque.empty(rc)) == 100
    }

    @test
    def foldLeft02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.foldLeft((i, e) -> (i - e) * (e `Int32.remainder` 2 + 1), 100, d) == 198
    }

    @test
    def foldLeft03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.foldLeft((i, e) -> (i - e) * (e `Int32.remainder` 2 + 1), 100, d) == 198
    }

    @test
    def foldLeft04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.foldLeft((i, e) -> (i - e) * (e `Int32.remainder` 2 + 1), 100, d) == 196
    }

    @test
    def foldLeft05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushFront(1, d);
        MutDeque.foldLeft((i, e) -> (i - e) * (e `Int32.remainder` 2 + 1), 100, d) == 386
    }


    /////////////////////////////////////////////////////////////////////////////
    // foldRight                                                               //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldRight01(): Bool = region rc {
        MutDeque.foldRight((e, acc) -> (acc - e) * (e `Int32.remainder` 2 + 1), 100, MutDeque.empty(rc)) == 100
    }

    @test
    def foldRight02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.foldRight((e, acc) -> (acc - e) * (e `Int32.remainder` 2 + 1), 100, d) == 198
    }

    @test
    def foldRight03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.foldRight((e, acc) -> (acc - e) * (e `Int32.remainder` 2 + 1), 100, d) == 198
    }

    @test
    def foldRight04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.foldRight((e, acc) -> (acc - e) * (e `Int32.remainder` 2 + 1), 100, d) == 194
    }

    @test
    def foldRight05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushFront(1, d);
        MutDeque.foldRight((e, acc) -> (acc - e) * (e `Int32.remainder` 2 + 1), 100, d) == 382
    }


    /////////////////////////////////////////////////////////////////////////////
    // foldRightWithCont                                                       //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldRightWithCont01(): Bool = region rc {
        MutDeque.foldRightWithCont((e, k) -> (k() - e) * (e `Int32.remainder` 2 + 1), 100, MutDeque.empty(rc)) == 100
    }

    @test
    def foldRightWithCont02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.foldRightWithCont((e, k) -> (k() - e) * (e `Int32.remainder` 2 + 1), 100, d) == 198
    }

    @test
    def foldRightWithCont03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.foldRightWithCont((e, k) -> (k() - e) * (e `Int32.remainder` 2 + 1), 100, d) == 198
    }

    @test
    def foldRightWithCont04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.foldRightWithCont((e, k) -> (k() - e) * (e `Int32.remainder` 2 + 1), 100, d) == 194
    }

    @test
    def foldRightWithCont05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushFront(1, d);
        MutDeque.foldRightWithCont((e, k) -> (k() - e) * (e `Int32.remainder` 2 + 1), 100, d) == 382
    }

    /////////////////////////////////////////////////////////////////////////////
    // foldMap                                                       //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def foldMap01(): Bool = region rc {
        MutDeque.foldMap(x -> 2 * x, MutDeque.empty(rc)) == 0
    }

    @test
    def foldMap02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.foldMap(x -> 2 * x, d) == 2
    }

    @test
    def foldMap03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.foldMap(x -> 2 * x, d) == 6
    }

    @test
    def foldMap04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.pushFront(1, d);
        MutDeque.foldMap(x -> 2 * x, d) == 12
    }

    @test
    def foldMap05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushFront("c", d);
        MutDeque.pushFront("b", d);
        MutDeque.pushFront("a", d);
        MutDeque.foldMap(x -> if (x == "c") "b" else x, d) == "abb"
    }

    @test
    def foldMap06(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.foldMap(Int32.toString, d) == "123"
    }


    /////////////////////////////////////////////////////////////////////////////
    // toList                                                                  //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toList01(): Bool = region rc {
        MutDeque.toList((MutDeque.empty(rc): MutDeque[Int32, _])) == (Nil: List[Int32])
    }

    @test
    def toList02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.toList(d) == 1 :: Nil
    }

    @test
    def toList03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.toList(d) == 1 :: 2 :: Nil
    }

    @test
    def toList04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.toList(d) == 1 :: 2 :: 3 :: Nil
    }


    /////////////////////////////////////////////////////////////////////////////
    // toArray                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toArray01(): Bool = region rc {
        let d = (MutDeque.empty(rc): MutDeque[Int32, _]);

        let a = MutDeque.toArray(rc, d);
        Array.sameElements(a, Array#{} @ rc)
    }

    @test
    def toArray02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);

        let a = MutDeque.toArray(rc, d);
        Array.sameElements(a, Array#{1} @ rc)
    }

    @test
    def toArray03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);

        let a = MutDeque.toArray(rc, d);
        Array.sameElements(a, Array#{1, 2} @ rc)
    }

    @test
    def toArray04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushFront(3, d);
        MutDeque.pushFront(4, d);

        let a = MutDeque.toArray(rc, d);
        Array.sameElements(a, Array#{4, 3, 1, 2} @ rc)
    }

    /////////////////////////////////////////////////////////////////////////////
    // toVector                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def toVector01(): Bool = region rc {
        let d = (MutDeque.empty(rc): MutDeque[Int32, _]);

        let v = MutDeque.toVector(d);
        v == Vector#{}
    }

    @test
    def toVector02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);

        let v = MutDeque.toVector(d);
        v == Vector#{1}
    }

    @test
    def toVector03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);

        let v = MutDeque.toVector(d);
        v == Vector#{1, 2}
    }

    @test
    def toVector04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushFront(3, d);
        MutDeque.pushFront(4, d);

        let v = MutDeque.toVector(d);
        v == Vector#{4, 3, 1, 2}
    }


    /////////////////////////////////////////////////////////////////////////////
    // join                                                                    //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def join01(): Bool = region rc {
        (MutDeque.empty(rc): MutDeque[Int32, _]) |> MutDeque.join(",") == ""
    }

    @test
    def join02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.join(",", d) == "1"
    }

    @test
    def join03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.join(",", d) == "1,2,3"
    }

    @test
    def join04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack("1", d);
        MutDeque.pushBack("2", d);
        MutDeque.pushBack("3", d);
        MutDeque.join(",", d) == "1,2,3"
    }


    /////////////////////////////////////////////////////////////////////////////
    // joinWith                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def joinWith01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.joinWith(x -> "${x + 1}", ",", d) == ""
    }

    @test
    def joinWith02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.joinWith(x -> "${x + 1}", ",", d) == "2"
    }

    @test
    def joinWith03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushBack(2, d);
        MutDeque.pushBack(3, d);
        MutDeque.joinWith(x -> "${x + 1}", ",", d) == "2,3,4"
    }

    @test
    def joinWith04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack("1", d);
        MutDeque.pushBack("2", d);
        MutDeque.pushBack("3", d);
        MutDeque.joinWith(x -> x + x, ",", d) == "11,22,33"
    }


    /////////////////////////////////////////////////////////////////////////////
    // iterator                                                                //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def iterator01(): Bool = region rc {
        let d = (MutDeque.empty(rc): MutDeque[Int32, rc]);
        let iter = MutDeque.iterator(rc, d);
        match Iterator.next(iter) {
            case None => true
            case _    => false
        }
    }

    @test
    def iterator02(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        let iter = MutDeque.iterator(rc, d);
        match Iterator.next(iter) {
            case Some(_) => true
            case _       => false
        }
    }

    @test
    def iterator03(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        discard MutDeque.popBack(d);
        discard MutDeque.popBack(d);
        discard MutDeque.popBack(d);
        let iter = MutDeque.iterator(rc, d);
        match Iterator.next(iter) {
            case None => true
            case _    => false
        }
    }

    @test
    def iterator04(): Bool = region rc {
        let d = List.toMutDeque(rc, 1 :: 2 :: 3 :: Nil);
        MutDeque.iterator(rc, d) |> Iterator.toList == 1 :: 2 :: 3 :: Nil
    }

    @test
    def iterator05(): Bool = region rc {
        let d = List.range(0, 100) |> List.toMutDeque(rc);
        MutDeque.iterator(rc, d) |> Iterator.toList == List.range(0, 100) and
        MutDeque.toList(d) == List.range(0, 100)
    }

    @test
    def iterator06(): Bool = region rc {
        let d = List.range(0, 100) |> List.toMutDeque(rc);
        let iter = MutDeque.iterator(rc, d);
        MutDeque.forEach(_ -> discard Iterator.next(iter), MutList.range(rc, 0, 50) |> MutList.toMutDeque(rc));
        iter |> Iterator.toList == List.range(50, 100) and
        MutDeque.toList(d) == List.range(0, 100)
    }

    /////////////////////////////////////////////////////////////////////////////
    // forEach                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def forEach01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        let l = Ref.fresh(rc, Nil);
        let fn = x -> if (x > 0) Ref.put("T" :: Ref.get(l), l) else Ref.put("F" :: Ref.get(l), l);
        MutDeque.forEach(fn, d);
        List.reverse(Ref.get(l)) |> List.join("") == ""
    }

    @test
    def forEach02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(0, d);
        let l = Ref.fresh(rc, Nil);
        let fn = x -> if (x > 0) Ref.put("T" :: Ref.get(l), l) else Ref.put("F" :: Ref.get(l), l);
        MutDeque.forEach(fn, d);
        List.reverse(Ref.get(l)) |> List.join("") == "F"
    }

    @test
    def forEach03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        let l = Ref.fresh(rc, Nil);
        let fn = x -> if (x > 0) Ref.put("T" :: Ref.get(l), l) else Ref.put("F" :: Ref.get(l), l);
        MutDeque.forEach(fn, d);
        List.reverse(Ref.get(l)) |> List.join("") == "T"
    }

    @test
    def forEach04(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(0, d);
        MutDeque.pushBack(1, d);
        let l = Ref.fresh(rc, Nil);
        let fn = x -> if (x > 0) Ref.put("T" :: Ref.get(l), l) else Ref.put("F" :: Ref.get(l), l);
        MutDeque.forEach(fn, d);
        List.reverse(Ref.get(l)) |> List.join("") == "FT"
    }

    @test
    def forEach05(): Bool = region rc {
        let d = MutDeque.empty(rc);
        MutDeque.pushBack(1, d);
        MutDeque.pushFront(0, d);
        let l = Ref.fresh(rc, Nil);
        let fn = x -> if (x > 0) Ref.put("T" :: Ref.get(l), l) else Ref.put("F" :: Ref.get(l), l);
        MutDeque.forEach(fn, d);
        List.reverse(Ref.get(l)) |> List.join("") == "FT"
    }

    /////////////////////////////////////////////////////////////////////////////
    // forEachWithIndex                                                        //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def forEachWithIndex01(): Bool = region rc {
        let d = MutDeque.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutDeque.forEachWithIndex((i, _) -> Ref.put(i, ri), d);
        21 == Ref.get(ri)
    }

    @test
    def forEachWithIndex02(): Bool = region rc {
        let d = MutDeque.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutDeque.pushBack(0, d);
        MutDeque.forEachWithIndex((i, _) -> Ref.put(i, ri), d);
        0 == Ref.get(ri)
    }

    @test
    def forEachWithIndex03(): Bool = region rc {
        let d = MutDeque.empty(rc);
        let ri = Ref.fresh(rc, 21);
        MutDeque.pushBack(0, d);
        MutDeque.pushBack(1, d);
        MutDeque.forEachWithIndex((i, _) -> Ref.put(i, ri), d);
        1 == Ref.get(ri)
    }

    /////////////////////////////////////////////////////////////////////////////
    // shuffle                                                                 //
    /////////////////////////////////////////////////////////////////////////////

    @test
    def shuffle01(): Bool \ NonDet = region rc {
        let l: List[Int32] = Nil;
        let d1 = List.toMutDeque(rc, l);
        let d2 = MutDeque.shuffle(rc, d1);

        MutDeque.size(d2) == 0 and d2 |> MutDeque.toList |> List.toSet == Set#{}
    }

    @test
    def shuffle02(): Bool \ NonDet = region rc {
        let l = 1 :: Nil;
        let d1 = List.toMutDeque(rc, l);
        let d2 = MutDeque.shuffle(rc, d1);

        MutDeque.size(d2) == 1 and d2 |> MutDeque.toList |> List.toSet == Set#{1}
    }

    @test
    def shuffle03(): Bool \ NonDet = region rc {
        let l = 1 :: 2 :: 3 :: Nil;
        let d1 = List.toMutDeque(rc, l);
        let d2 = MutDeque.shuffle(rc, d1);

        MutDeque.size(d2) == 3 and d2 |> MutDeque.toList |> List.toSet == Set#{1, 2, 3}
    }

    @test
    def shuffle04(): Bool \ NonDet = region rc {
        let l = 0 :: 1 :: 2 :: 3 :: 4 :: 5 :: 6 :: 7 :: 8 :: 9 :: Nil;
        let d1 = List.toMutDeque(rc, l);
        let d2 = MutDeque.shuffle(rc, d1);

        MutDeque.size(d2) == 10 and
            d2 |> MutDeque.toList |> List.toSet == Set#{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    }

}
