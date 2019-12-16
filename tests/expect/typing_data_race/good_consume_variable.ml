open Core
open Print_data_race

let%expect_test "Consume variable" =
  print_data_race
    " 
    class Foo = linear Bar {
      const f : int
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
      require const f : int
      require const g : int  
      require const h : int
    }
    {    
      let x = new Foo(f:4, g:5, h:6) in
        let y = consume x in (* Consume linear variable *)
          let z = 5 in
            let w = consume z in (* Can consume an int *)
              y.h
            end
          end
        end
      end ;
      let x = new Choco(f:5) in
        let y = consume x in 
          y
        end
      end;
        let x = new Bana(f:5) in
        let y = consume x in 
          y
        end
      end
    }
  " ;
  [%expect {| |}]
