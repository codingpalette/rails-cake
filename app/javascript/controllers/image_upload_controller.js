import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dropZone", "input", "preview", "previewContainer", "dropZoneContent"]
  
  connect() {
    console.log("Image upload controller connected")
    this.selectedFiles = []
    this.maxFiles = 5
  }
  
  disconnect() {
    console.log("Image upload controller disconnected")
    // Stimulus가 자동으로 이벤트 리스너를 정리합니다
  }
  
  dragOver(event) {
    event.preventDefault()
    this.dropZoneTarget.classList.add('border-orange-400', 'bg-orange-50')
  }
  
  dragLeave(event) {
    event.preventDefault()
    this.dropZoneTarget.classList.remove('border-orange-400', 'bg-orange-50')
  }
  
  drop(event) {
    event.preventDefault()
    this.dropZoneTarget.classList.remove('border-orange-400', 'bg-orange-50')
    
    const files = Array.from(event.dataTransfer.files).filter(file => file.type.startsWith('image/'))
    this.handleFiles(files)
  }
  
  inputChange(event) {
    const files = Array.from(event.target.files)
    this.handleFiles(files)
  }
  
  handleFiles(files) {
    // 최대 파일 개수 체크
    if (this.selectedFiles.length + files.length > this.maxFiles) {
      alert(`최대 ${this.maxFiles}장까지 업로드할 수 있습니다.`)
      files = files.slice(0, this.maxFiles - this.selectedFiles.length)
    }
    
    files.forEach(file => {
      if (file.type.startsWith('image/')) {
        this.selectedFiles.push(file)
        this.addPreviewImage(file)
      }
    })
    
    this.updateFileInput()
    this.updateDropZoneState()
  }
  
  addPreviewImage(file) {
    const reader = new FileReader()
    
    reader.onload = (e) => {
      const previewItem = document.createElement('div')
      previewItem.className = 'relative group'
      previewItem.innerHTML = `
        <div class="relative">
          <img src="${e.target.result}" alt="미리보기" class="w-full h-24 object-cover rounded-lg border border-gray-200">
          <button type="button" data-action="click->image-upload#removeImage" data-index="${this.selectedFiles.length - 1}" class="absolute -top-2 -right-2 w-6 h-6 bg-red-500 text-white rounded-full text-xs hover:bg-red-600 transition-colors opacity-0 group-hover:opacity-100">
            <svg class="w-3 h-3 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
            </svg>
          </button>
        </div>
      `
      this.previewContainerTarget.appendChild(previewItem)
    }
    
    reader.readAsDataURL(file)
  }
  
  removeImage(event) {
    const button = event.currentTarget
    const index = parseInt(button.dataset.index)
    const previewItem = button.closest('.group')
    
    if (index !== -1) {
      this.selectedFiles.splice(index, 1)
      previewItem.remove()
      this.updateFileInput()
      this.updateDropZoneState()
      
      // 인덱스 재조정
      this.previewContainerTarget.querySelectorAll('button[data-action="click->image-upload#removeImage"]').forEach((btn, i) => {
        btn.dataset.index = i
      })
    }
  }
  
  updateFileInput() {
    const dt = new DataTransfer()
    this.selectedFiles.forEach(file => dt.items.add(file))
    this.inputTarget.files = dt.files
  }
  
  updateDropZoneState() {
    if (this.selectedFiles.length > 0) {
      this.previewTarget.classList.remove('hidden')
      this.dropZoneContentTarget.innerHTML = `
        <div class="space-y-2">
          <div class="mx-auto w-12 h-12 bg-gray-100 rounded-full flex items-center justify-center">
            <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
            </svg>
          </div>
          <p class="text-gray-600 font-medium text-sm">이미지 더 추가</p>
          <p class="text-xs text-gray-500">${this.selectedFiles.length}/${this.maxFiles}</p>
        </div>
      `
    } else {
      this.previewTarget.classList.add('hidden')
      this.dropZoneContentTarget.innerHTML = `
        <div class="space-y-4">
          <div class="mx-auto w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center">
            <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
            </svg>
          </div>
          <div>
            <p class="text-gray-600 font-medium">이미지 추가</p>
            <p class="text-sm text-gray-500">클릭하거나 이미지를 드래그해주세요</p>
          </div>
        </div>
      `
    }
  }
}