<style>
  .container {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .control, .input {
    flex-shrink: 0;
  }

  .output {
    flex-grow: 1;
    overflow: scroll;
  }

  pre {
    margin: 0;
  }
</style>

<script>
  let loading = false;
  let status = {};
  let output_lines = [];
  let next_command = "";

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
    const websocket = new WebSocket(`ws://${document.location.host}`);
    websocket.onopen = () => console.log("Opened!");
    websocket.onclose = () => console.log("Closed!");
    websocket.onmessage = (evt) => {
      output_lines[output_lines.length] = evt.data;
    }
    websocket.onerror = (evt) => console.log("Error", evt)
  }

  function send() {
    sendCommand(next_command);
    next_command = "";
  }

  fetchStatus();
  connectWS();
</script>


<div class="container">
  <div class="control">
    {#if status}
      <button disabled={loading} on:click={() => status.running ? stop() : start()}>
        {status.running ? 'Stop' : 'Start'}
      </button>
    {/if}
  </div>
  <div class="output">
    {#each output_lines as line}
      <pre>{line}</pre>
    {/each}
  </div>
  <div class="input">
    <form on:submit|preventDefault={send}>
      <input disabled={loading} type="text" bind:value={next_command}>
    </form>
  </div>
</div>
