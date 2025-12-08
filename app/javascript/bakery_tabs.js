// Tab switching functionality for bakery show page
export function initializeTabs() {
  // Expose switchTab function to global scope for onclick handlers
  window.switchTab = function(tabName) {
    // Find the active tab element
    const activeTab = document.getElementById(tabName + '-tab');
    const activeContent = document.getElementById(tabName + '-content');

    // Check if elements exist
    if (!activeTab || !activeContent) {
      console.error('Tab elements not found:', tabName);
      return;
    }

    // Remove active class from all tabs
    document.querySelectorAll('.tab-button').forEach(button => {
      button.classList.remove('active', 'border-orange-500', 'text-orange-600');
      button.classList.add('border-transparent', 'text-gray-500');
    });

    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(content => {
      content.classList.add('hidden');
    });

    // Add active class to clicked tab
    activeTab.classList.add('active', 'border-orange-500', 'text-orange-600');
    activeTab.classList.remove('border-transparent', 'text-gray-500');

    // Show selected tab content
    activeContent.classList.remove('hidden');
  };

  // Initialize to menu tab by default
  const menuTab = document.getElementById('menu-tab');
  if (menuTab) {
    window.switchTab('menu');
  }
}

// Initialize tabs on page load and Turbo navigation
document.addEventListener('DOMContentLoaded', initializeTabs);
document.addEventListener('turbo:load', initializeTabs);
document.addEventListener('turbo:render', initializeTabs);
