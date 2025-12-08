# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bakery show page scripts
pin "bakery_image_modal", to: "bakery_image_modal.js"
pin "bakery_tabs", to: "bakery_tabs.js"
pin "bakery_menu_modal", to: "bakery_menu_modal.js"
