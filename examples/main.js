import init, { greet, start_oauth_flow } from '/pkg/oauth_blob_optimized.js';

async function run() {
  // Initialize the wasm module
  await init();

  const output = document.getElementById('output');

  function log(message) {
    output.textContent += message + '\n';
    output.scrollTop = output.scrollHeight;
  }

  function clearOutput() {
    output.textContent = '';
  }

  document.getElementById('test-oauth').addEventListener('click', async () => {
    log('Testing OAuth flow...');
    const clientId = prompt('Enter your GitHub client ID:');
    if (!clientId) {
      log('No client ID provided');
      return;
    }

    try {
      log('Starting OAuth flow...');
      const result = await start_oauth_flow(clientId, 'read:user');
      log('Success: ' + result);
    } catch (error) {
      log('Error: ' + error);
    }
  });

  document.getElementById('clear-output').addEventListener('click', clearOutput);

  log('WASM module loaded successfully!');
  log('Note: Build the WASM package first with:');
  log('  just package');
  log('Then serve this directory with a local HTTP server');
}

run();
