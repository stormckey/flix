mod Test.Handler.NewObject {

    import java.lang.Runnable

    eff Ask {
        def ask(x: Int32): Unit
    }

    eff Gen {
        def gen(): Int32
    }

    def newAskRunnable(r: Ref[Int32, rc]): Runnable \ IO = new Runnable {
        def $run(_this: Runnable): Unit \ { rc } =
            run {
              Ask.ask(42)
            } with handler Ask {
                def ask(x, _) = Ref.put(x, r)
            }
    }

    def newGenRunnable(r: Ref[Int32, rc]): Runnable \ IO = new Runnable {
        def $run(_this: Runnable): Unit \ { rc } =
            run {
              Ref.put(Gen.gen(), r)
            } with handler Gen {
                def gen(k) = k(42)
            }
    }

    def newGenAskRunnable(r: Ref[Int32, rc]): Runnable \ IO = new Runnable {
        def $run(_this: Runnable): Unit \ { rc } =
            run {
                Ask.ask(
                    run {
                        Gen.gen()
                    } with handler Gen {
                        def gen(k) = k(42)
                    }
                )
            } with handler Ask {
                def ask(x, _) = Ref.put(x + x, r)
            }
    }

    @Test
    def testRunnable01(): Bool \ IO =
        region rc {
            let r = Ref.fresh(rc, 0);
            newAskRunnable(r).$run();
            let result = Ref.get(r);
            Assert.eq(42, result)
        }

    @Test
    def testRunnable02(): Bool \ IO =
        region rc {
            let r = Ref.fresh(rc, 0);
            newGenRunnable(r).$run();
            let result = Ref.get(r);
            Assert.eq(42, result)
        }

    @Test
    def testRunnable03(): Bool \ IO =
        region rc {
            let r = Ref.fresh(rc, 0);
            newGenAskRunnable(r).$run();
            let result = Ref.get(r);
            Assert.eq(84, result)
        }

}
