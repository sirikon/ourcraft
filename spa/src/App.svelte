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

  fetchStatus();
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