// Image modal functionality for bakery show page
export function initializeImageModal() {
  // Global variable for images array
  if (typeof window.bakeryImages === 'undefined') {
    window.bakeryImages = [];
  }

  // Store original bakery images separately
  if (typeof window.originalBakeryImages === 'undefined') {
    window.originalBakeryImages = [];
  }

  // Global variable for current image index
  if (typeof window.currentImageIndex === 'undefined') {
    window.currentImageIndex = 0;
  }

  // Save original bakery images when they are set
  if (window.bakeryImages.length > 0 && window.originalBakeryImages.length === 0) {
    window.originalBakeryImages = [...window.bakeryImages];
  }

  // Expose functions to global scope for onclick handlers
  window.openImageModal = function(index) {
    // Restore original bakery images before opening modal
    if (window.originalBakeryImages.length > 0) {
      window.bakeryImages = [...window.originalBakeryImages];
    }
    window.currentImageIndex = index;
    const modal = document.getElementById('imageModal');
    if (modal) {
      modal.classList.remove('hidden');
      updateModalImage();
      updateNavigationButtons();
    }
  };

  window.closeImageModal = function() {
    const modal = document.getElementById('imageModal');
    if (modal) {
      modal.classList.add('hidden');
    }
  };

  window.changeImage = function(direction) {
    window.currentImageIndex = (window.currentImageIndex + direction + window.bakeryImages.length) % window.bakeryImages.length;
    updateModalImage();
  };

  function updateModalImage() {
    const modalImage = document.getElementById('modalImage');
    const imageCounter = document.getElementById('imageCounter');

    if (modalImage && window.bakeryImages.length > 0) {
      modalImage.src = window.bakeryImages[window.currentImageIndex];
    }

    if (imageCounter) {
      imageCounter.textContent = `${window.currentImageIndex + 1} / ${window.bakeryImages.length}`;
    }
  }

  function updateNavigationButtons() {
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    if (window.bakeryImages.length > 1) {
      if (prevBtn) prevBtn.classList.remove('hidden');
      if (nextBtn) nextBtn.classList.remove('hidden');
    } else {
      if (prevBtn) prevBtn.classList.add('hidden');
      if (nextBtn) nextBtn.classList.add('hidden');
    }
  }

  // Close modal with Escape key and navigate with arrow keys
  document.addEventListener('keydown', function(e) {
    const modal = document.getElementById('imageModal');
    if (!modal || modal.classList.contains('hidden')) return;

    if (e.key === 'Escape') {
      window.closeImageModal();
    } else if (e.key === 'ArrowLeft' && window.bakeryImages.length > 1) {
      window.changeImage(-1);
    } else if (e.key === 'ArrowRight' && window.bakeryImages.length > 1) {
      window.changeImage(1);
    }
  });
}

// Note image modal functionality
export function initializeNoteImageModal() {
  window.openNoteImageModal = function(noteId, imageIndex) {
    const noteImages = window.noteImagesData?.[noteId];
    if (!noteImages || noteImages.length === 0) return;

    window.bakeryImages = noteImages;
    window.currentImageIndex = imageIndex;
    const modal = document.getElementById('imageModal');
    if (modal) {
      modal.classList.remove('hidden');
      const modalImage = document.getElementById('modalImage');
      const imageCounter = document.getElementById('imageCounter');
      const prevBtn = document.getElementById('prevBtn');
      const nextBtn = document.getElementById('nextBtn');

      if (modalImage) {
        modalImage.src = noteImages[imageIndex];
      }
      if (imageCounter) {
        imageCounter.textContent = `${imageIndex + 1} / ${noteImages.length}`;
      }

      // Show/hide navigation buttons based on image count
      if (noteImages.length > 1) {
        if (prevBtn) prevBtn.classList.remove('hidden');
        if (nextBtn) nextBtn.classList.remove('hidden');
      } else {
        if (prevBtn) prevBtn.classList.add('hidden');
        if (nextBtn) nextBtn.classList.add('hidden');
      }
    }
  };
}
