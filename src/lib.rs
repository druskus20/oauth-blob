use js_sys::Promise;
use wasm_bindgen::prelude::*;
use web_sys::console;

use github_device_oauth::*;

#[wasm_bindgen]
extern "C" {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet(name: &str) {
    alert(&format!("Hello, {}!", name));
}

#[wasm_bindgen]
pub fn start_oauth_flow(client_id: String, scopes: Option<String>) -> Promise {
    wasm_bindgen_futures::future_to_promise(async move {
        let result = run_oauth(client_id, scopes.unwrap_or_else(|| "read:user".to_string())).await;
        match result {
            Ok(creds) => Ok(JsValue::from_str(&format!(
                "Access token: {}",
                creds.access_token
            ))),
            Err(e) => Err(JsValue::from_str(&format!("Error: {}", e))),
        }
    })
}

async fn run_oauth(
    client_id: String,
    scopes: String,
) -> Result<Credentials, Box<dyn std::error::Error>> {
    let refresh_token = None; // For now, start fresh each time
    let host = "github.com".to_owned();
    let flow = DeviceFlow::new(client_id, host, scopes);
    let cred = flow.refresh_or_authorize(refresh_token).await?;
    Ok(cred)
}
