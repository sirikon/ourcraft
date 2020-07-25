<style>
  h1 {
    color: purple;
  }
  
  h1.disabled {
    opacity: 0.2;
  }
</style>

<script>
  let loading = false;
  let status = {};

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
    websocket.onmessage = (evt) => console.log("Message", evt)
    websocket.onerror = (evt) => console.log("Error", evt)
  }

  fetchStatus();
  connectWS();
</script>

<h1 class:disabled={loading}>Status: {status.running ? 'Running' : 'Stopped'}</h1>
{#if status}
  {#if status.running}
    <button disabled={loading} on:click={stop}>Stop</button>
  {:else}
    <button disabled={loading} on:click={start}>Start</button>
  {/if}
{/if}
{#if loading}
  <span>Loading...</span>
{/if}
<button on:click={() => sendCommand("list")}>list</button>
