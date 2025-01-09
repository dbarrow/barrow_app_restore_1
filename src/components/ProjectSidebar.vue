<script setup lang="ts">
import { ref } from 'vue'

const isCollapsed = ref(false)

const toggleSidebar = () => {
  isCollapsed.value = !isCollapsed.value
}
</script>

<template>
  <aside 
    class="h-full bg-gray-800 text-white transition-all duration-300 flex flex-col border-r border-gray-700"
    :class="isCollapsed ? 'w-14' : 'w-64'"
  >
    <!-- Sidebar header with toggle -->
    <div class="p-3 flex justify-between items-center border-b border-gray-700">
      <h2 class="font-semibold text-sm truncate" :class="{ 'hidden': isCollapsed }">Projects</h2>
      <button 
        @click="toggleSidebar"
        class="p-1.5 hover:bg-gray-700 rounded transition-colors"
        :title="isCollapsed ? 'Expand' : 'Collapse'"
      >
        <svg 
          class="w-4 h-4 transition-transform"
          :class="{ 'rotate-180': isCollapsed }"
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path 
            stroke-linecap="round" 
            stroke-linejoin="round" 
            stroke-width="2" 
            d="M11 19l-7-7 7-7m8 14l-7-7 7-7" 
          />
        </svg>
      </button>
    </div>
    
    <!-- Project list -->
    <div class="flex-1 overflow-y-auto">
      <div 
        v-for="i in 5" 
        :key="i"
        class="flex items-center hover:bg-gray-700 cursor-pointer transition-colors border-l-4 border-transparent hover:border-indigo-500"
        :class="[
          isCollapsed ? 'justify-center py-3' : 'px-3 py-2',
        ]"
      >
        <div class="flex items-center gap-2 min-w-0">
          <div class="w-2 h-2 rounded-full bg-green-500 flex-shrink-0"></div>
          <span 
            class="truncate text-sm text-gray-300"
            :class="{ 'hidden': isCollapsed }"
          >
            Project {{ i }}
          </span>
        </div>
      </div>
    </div>
  </aside>
</template>