<style>
  .container {
    display: flex;
    flex-direction: column;
    height: 100%;
    max-width: 1100px;
    margin: auto;
  }

  .control, .input {
    flex-shrink: 0;
  }

  .output, .output-wrapper {
    flex-grow: 1;
  }

  .output {
    overflow-x: hidden;
    overflow-y: scroll;
    padding: 10px 10px 0 10px;
  }

  .output-wrapper {
    display: flex;
    flex-direction: column;
    margin: 0px 10px;
    background-color: #3c3c3c;
    color: white;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
    overflow: hidden;
  }

  .control {
    background-color: whitesmoke;
    padding: 10px;
    margin: 10px;
    border-radius: 6px;
  }

  .output pre {
    margin: 0;
    white-space: break-spaces;
    font-size: 12px;
  }

  .output pre:last-child {
    margin-bottom: 10px;
  }

  .input {
    color: white;
    font-family: monospace;
    margin: 0 10px 10px 10px;
    padding-left: 10px;
    border-bottom-left-radius: 6px;
    border-bottom-right-radius: 6px;
    overflow: hidden;
    background-color: #4a4a4a;
    font-size: 12px;
  }

  .input form {
    display: flex;
    flex-direction: row;
    justify-content: stretch;
    align-items: center;
  }

  .input form input {
    appearance: none;
    -moz-appearance: none;
    -webkit-appearance: none;
    width: 100%;
    box-sizing: border-box;
    border: none;
    padding: 10px 10px 10px 0;
    color: white;
    font-family: monospace;
    background-color: transparent;
    font-size: 12px;
  }

  .input form input:focus {
    outline: none;
  }
</style>

<script>
  import { onMount, afterUpdate } from 'svelte';

  let loading = false;
  let status = {};
  let output_lines = [];
  let next_command = "";
  let output_el;
  let keepOnBottom = false;

  function fetchStatus() {
    loading = true;
    fetch("/api/minecraft_process/status")
      .then(r => r.json())
      .then(data => {
        status = data;
        loading = false;
      });
  }

  function start() {
    loading = true;
    fetch("/api/minecraft_process/start", { method: 'POST' })
      .then(_ => {
        fetchStatus();
      });
  }

  function stop() {
    loading = true;
    fetch("/api/minecraft_process/stop", { method: 'POST' })
      .then(_ => {
        fetchStatus();
      });
  }

  function sendCommand(command) {
    fetch("/api/minecraft_process/send_command", {
      method: 'POST',
      body: JSON.stringify({command})
    });
  }

  function connectWS() {
    const websocket = new WebSocket(getWSAddress());
    websocket.onopen = () => console.log("Opened!");
    websocket.onclose = () => console.log("Closed!");
    websocket.onmessage = (evt) => addOutputLine(evt.data);
    websocket.onerror = (evt) => console.log("Error", evt)
  }

  function getWSAddress() {
    const protocol = document.location.protocol === 'https:' ? 'wss:' : 'ws:'
    return `${protocol}//${document.location.host}`;
  }

  function addOutputLine(line) {
    if (output_el.scrollTop === getScrollTopMax(output_el)) {
      keepOnBottom = true;
    }
    output_lines[output_lines.length] = line;
  }

  function getScrollTopMax(el) {
    if (el.scrollTopMax !== undefined) {
      return el.scrollTopMax;
    }
    return el.scrollHeight - el.getBoundingClientRect().height;
  }

  function send() {
    sendCommand(next_command);
    next_command = "";
  }

  onMount(() => {
    fetchStatus();
    connectWS();
  });

  afterUpdate(() => {
    if (keepOnBottom) {
      output_el.scrollTop = output_el.scrollHeight;
      keepOnBottom = false;
    }
	});
</script>


<div class="container">
  <div class="control">
    {#if status}
      <button disabled={loading} on:click={() => status.running ? stop() : start()}>
        {status.running ? 'Stop' : 'Start'}
      </button>
    {/if}
  </div>
  <div class="output-wrapper">
    <div class="output" bind:this={output_el}>
      {#each output_lines as line}
        <pre>{line}</pre>
      {/each}
    </div>
  </div>
  <div class="input">
    <form on:submit|preventDefault={send}>
      <span>>&nbsp;</span>
      <input disabled={loading} type="text" bind:value={next_command}>
    </form>
  </div>
</div>
