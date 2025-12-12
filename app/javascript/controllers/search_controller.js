import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "empty"]
  static values = {
    url: String
  }

  connect() {
    this.timeout = null

    // 검색어가 있으면 입력 필드에 포커스하고 커서를 끝으로 이동
    if (this.inputTarget.value) {
      this.inputTarget.focus()
      const length = this.inputTarget.value.length
      this.inputTarget.setSelectionRange(length, length)
    }
  }

  search() {
    clearTimeout(this.timeout)

    // 500ms 디바운스 적용
    this.timeout = setTimeout(() => {
      this.performSearch()
    }, 500)
  }

  async performSearch() {
    const query = this.inputTarget.value.trim()
    const url = new URL(this.urlValue, window.location.origin)

    if (query) {
      url.searchParams.set("query", query)
    }

    // Turbo로 페이지 방문 (검색 결과 갱신)
    Turbo.visit(url.toString(), { action: "replace" })
  }

  clear() {
    this.inputTarget.value = ""
    this.performSearch()
  }
}
