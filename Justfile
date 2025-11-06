set positional-arguments

install: install-binarygen install-wasm-bindgen

install-binarygen:
  ./scripts/install_binarygen.sh

install-wasm-bindgen:
  cargo install -f wasm-bindgen-cli --version 0.2.105

debug:
  cargo build --target wasm32-unknown-unknown 
  wasm-opt -Oz --enable-bulk-memory target/wasm32-unknown-unknown/debug/oauth_blob.wasm -o target/debug/oauth_blob_optimized.wasm
  @echo "WASM generated at target/debug/oauth_blob_optimized.wasm"
  @echo "WASM size (debug): $(($(stat -c%s target/debug/oauth_blob_optimized.wasm) / 1024)) KB"


release:
  cargo build --target wasm32-unknown-unknown --release
  wasm-opt -Oz --enable-bulk-memory target/wasm32-unknown-unknown/release/oauth_blob.wasm -o target/release/oauth_blob_optimized.wasm
  @echo "WASM generated at target/release/oauth_blob_optimized.wasm"
  @echo "WASM size (release): $(($(stat -c%s target/release/oauth_blob_optimized.wasm) / 1024)) KB"

package: release
  rm -rf pkg
  wasm-bindgen --out-dir pkg --web target/release/oauth_blob_optimized.wasm

example: package
  @which miniserve || (cargo binstall miniserve && miniserve .)  
  @echo "Open http://localhost:8080/examples/index.html in your browser"
  @miniserve . >/dev/null 




