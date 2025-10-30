```python
def greet():
    print("Hello, Python!")
greet()
```

```javascript
console.log("Hello, world!");
```


```typescript
console.log("Hello, TypeScript!");
```

```js
console.log("Hello, JavaScript!");
```

```typescript
let a: number = 5;
let b: number = 10;
let sum: number = a + b;
console.log("sum:",sum);
```


```go
package main

import (
    "fmt"
    "net/http"
    "time"
)

func greet(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello World! %s", time.Now())
}

func main() {
    http.HandleFunc("/", greet)
    http.ListenAndServe(":8080", nil)
}
```

```c
#include <stdio.h>
int main() {
    printf("Hello, C!\n");
    return 0;
}
```

```cs
Console.WriteLine("Hello, .NET!");
```

```fsharp
printfn "Hello, FSharp!"
```

```rust
fn main() {
    println!("Hello, Rust!");
}
```

```lua
local env = os.getenv 'GEMINI_API_KEY'
print("Hello, Lua!", env)
```

```ocaml
let () = print_endline "Hello, OCaml!"
```

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```
