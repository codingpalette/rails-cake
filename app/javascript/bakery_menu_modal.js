// Menu modal functionality for admin users
export function initializeMenuModal() {
  // Expose modal functions to global scope for onclick handlers
  window.openAddMenuModal = function() {
    const modal = document.getElementById('addMenuModal');
    if (modal) {
      modal.classList.remove('hidden');
    }
  };

  window.closeAddMenuModal = function() {
    const modal = document.getElementById('addMenuModal');
    if (modal) {
      modal.classList.add('hidden');
    }
  };
}
