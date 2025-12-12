import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sentinel", "container"]
  static values = {
    url: String,
    page: { type: Number, default: 1 },
    loading: { type: Boolean, default: false },
    hasMore: { type: Boolean, default: true }
  }

  connect() {
    this.setupIntersectionObserver()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  setupIntersectionObserver() {
    const options = {
      root: null,
      rootMargin: "100px",  // 100px 전에 미리 로딩 시작
      threshold: 0
    }

    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !this.loadingValue && this.hasMoreValue) {
          this.loadMore()
        }
      })
    }, options)

    if (this.hasSentinelTarget) {
      this.observer.observe(this.sentinelTarget)
    }
  }

  async loadMore() {
    this.loadingValue = true
    this.pageValue++

    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("page", this.pageValue)

    try {
      const response = await fetch(url, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "Turbo-Frame": "bakeries-page"
        }
      })

      if (!response.ok) throw new Error("Network response was not ok")

      const html = await response.text()

      // 새 콘텐츠 추가
      const parser = new DOMParser()
      const doc = parser.parseFromString(html, "text/html")
      const newContent = doc.querySelector("#bakeries-content")

      if (newContent && newContent.innerHTML.trim()) {
        this.containerTarget.insertAdjacentHTML("beforeend", newContent.innerHTML)

        // 다음 페이지 URL 업데이트
        const nextPageLink = doc.querySelector("[data-next-page]")
        if (!nextPageLink) {
          this.hasMoreValue = false
          this.hideSentinel()
        }
      } else {
        this.hasMoreValue = false
        this.hideSentinel()
      }
    } catch (error) {
      console.error("무한 스크롤 로딩 실패:", error)
    } finally {
      this.loadingValue = false
    }
  }

  hideSentinel() {
    if (this.hasSentinelTarget) {
      this.sentinelTarget.style.display = "none"
    }
  }
}
