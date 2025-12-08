class AllNotesController < ApplicationController
  before_action :require_authentication

  def index
    @notes = Current.user.notes.includes(:bakery, images_attachments: :blob).recent
    @notes_by_month = @notes.group_by { |note| note.visit_date.beginning_of_month }
  end
end