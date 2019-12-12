open Core
open Print_data_race

let%expect_test "Consume variable" =
  print_data_race
    " 
    class Foo = linear Bar {
      var f : int
      const g : int  
      const h : int

    }
    class Choco = thread Late {
      const f : int
    }
    class Bana = read Na {
      const f : int
    }
    thread trait Late {
      require const f : int
    }
    read trait Na {
      require const f : int
    }
    linear trait Bar {
      require var f : int
      require const g : int  
      require const h : int
    }
  let x = new Choco(f:5) in 
      finish {
        async{
          let f = fun x : int -> x end in
            f 5
          end 
        }
        async{
          let y = new Choco(f:5) in 
            let z = new Bana(f:1) in 
              let w = new Foo(g:5) in 
                w.f := 5
              end
            end
          end
        }
      };
      x
  end
  " ;
  [%expect {| |}]