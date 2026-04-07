<template>
  <div class="app-container home">
  欢迎使用本系统
  </div>
</template>

<script>
export default {
  name: "Index",
  data() {
    return {
    }
  },
  methods: {
    goTarget(href) {
      window.open(href, "_blank")
    }
  }
}
</script>

<style scoped lang="scss">
.home {
}
</style>

