set positional-arguments

install-binarygen:
  ./scripts/install_binarygen.sh

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

