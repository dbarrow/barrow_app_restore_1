<template>
  <div class="flex flex-1 overflow-hidden">
    <!-- Left sidebar (Master) -->
    <div class="w-1/3 border-r border-gray-200 overflow-y-auto bg-gray-50">
      <slot name="master"></slot>
    </div>

    <!-- Main content (Detail) -->
    <main class="flex-1 overflow-y-auto bg-white">
      <slot name="detail"></slot>
    </main>
  </div>
</template>