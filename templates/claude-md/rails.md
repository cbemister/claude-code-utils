# [Project Name] - Project Documentation

## Overview
[Brief description of what this Rails application does and its primary purpose]

## Tech Stack
- **Ruby** [version, e.g., 3.3+] with **Rails** [version, e.g., 7.1+]
- **PostgreSQL** for the primary database
- **Hotwire** — Turbo (Streams, Frames) + Stimulus for reactive UI without a SPA
- **Tailwind CSS** via `tailwindcss-rails`
- **RSpec** and **FactoryBot** for testing
- **Rubocop** with `rubocop-rails` for linting
- **Active Job** + **Sidekiq** for background jobs
- **[Deployment]** - Kamal / Heroku / Fly.io / Render

## Project Structure
```
app/
├── assets/
├── channels/                  # Action Cable WebSocket channels
├── controllers/
│   ├── application_controller.rb
│   └── [resources]_controller.rb
├── javascript/
│   ├── controllers/           # Stimulus controllers
│   │   ├── index.js
│   │   └── [name]_controller.js
│   └── application.js
├── jobs/                      # Active Job classes
├── mailers/
├── models/
│   ├── application_record.rb
│   └── [model].rb
├── views/
│   ├── layouts/
│   │   └── application.html.erb
│   └── [resources]/
│       ├── index.html.erb
│       ├── show.html.erb
│       ├── new.html.erb
│       ├── edit.html.erb
│       └── _[partial].html.erb

config/
├── application.rb
├── database.yml
├── routes.rb
└── environments/
    ├── development.rb
    ├── test.rb
    └── production.rb

db/
├── migrate/                   # Migration files
├── schema.rb                  # Current schema (auto-generated)
└── seeds.rb

spec/
├── spec_helper.rb
├── rails_helper.rb
├── factories/                 # FactoryBot factories
├── models/
├── requests/                  # Request (integration) specs
├── system/                    # Capybara browser specs
└── support/                   # Shared helpers, matchers

Gemfile
.rubocop.yml
```

## Models

### Model Pattern
```ruby
# app/models/item.rb
class Item < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  enum :status, { draft: 0, published: 1, archived: 2 }

  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }

  def published?
    status == "published"
  end
end
```

### Migration Pattern
```ruby
# db/migrate/YYYYMMDDHHMMSS_create_items.rb
class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :title, null: false, limit: 255
      t.text :description
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :items, [:user_id, :status]
  end
end
```

## Controllers

### Standard RESTful Controller
```ruby
# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy, :publish]

  def index
    @items = current_user.items.recent.page(params[:page]).per(20)
  end

  def show; end

  def new
    @item = Item.new
  end

  def create
    @item = current_user.items.new(item_params)
    if @item.save
      redirect_to @item, notice: "Item created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: "Item updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path, notice: "Item deleted."
  end

  def publish
    @item.published!
    redirect_to @item, notice: "Item published."
  end

  private

  def set_item
    @item = current_user.items.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :status)
  end
end
```

## Hotwire

### Turbo Frames
```erb
<%# app/views/items/index.html.erb %>
<turbo-frame id="items-list">
  <%= render @items %>
  <%= render "pagination", items: @items %>
</turbo-frame>
```

```erb
<%# app/views/items/_item.html.erb %>
<turbo-frame id="<%= dom_id(item) %>">
  <div class="p-4 bg-white rounded-lg shadow">
    <h3 class="text-lg font-medium"><%= item.title %></h3>
    <div class="mt-2 flex gap-2">
      <%= link_to "Edit", edit_item_path(item) %>
      <%= button_to "Delete", item, method: :delete,
          data: { turbo_confirm: "Are you sure?" } %>
    </div>
  </div>
</turbo-frame>
```

### Turbo Streams (Real-time updates)
```ruby
# In controller after save:
respond_to do |format|
  format.turbo_stream do
    render turbo_stream: [
      turbo_stream.prepend("items-list", partial: "items/item", locals: { item: @item }),
      turbo_stream.update("flash", partial: "shared/flash", locals: { notice: "Created!" }),
    ]
  end
  format.html { redirect_to @item }
end
```

### Stimulus Controllers
```javascript
// app/javascript/controllers/character_counter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "count"]
  static values = { max: Number }

  connect() {
    this.update()
  }

  update() {
    const remaining = this.maxValue - this.inputTarget.value.length
    this.countTarget.textContent = remaining
    this.countTarget.classList.toggle("text-red-500", remaining < 20)
  }
}
```

```erb
<div data-controller="character-counter" data-character-counter-max-value="255">
  <%= f.text_field :title, data: { character_counter_target: "input",
      action: "input->character-counter#update" } %>
  <span data-character-counter-target="count"></span> remaining
</div>
```

## Background Jobs (Sidekiq)

```ruby
# app/jobs/send_notification_job.rb
class SendNotificationJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform(user_id, message)
    user = User.find(user_id)
    UserMailer.notification(user, message).deliver_now
  end
end

# Enqueue from controller or model:
SendNotificationJob.perform_later(user.id, "Your item was published!")
SendNotificationJob.set(wait: 5.minutes).perform_later(user.id, "Reminder")
```

## Routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "dashboard#index"

  devise_for :users

  resources :items do
    member do
      patch :publish
    end
    resources :comments, only: [:create, :destroy]
  end

  # API namespace
  namespace :api do
    namespace :v1 do
      resources :items, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
```

## Testing (RSpec + FactoryBot)

### Factory
```ruby
# spec/factories/items.rb
FactoryBot.define do
  factory :item do
    association :user
    title { Faker::Lorem.sentence(word_count: 4) }
    description { Faker::Lorem.paragraph }
    status { :draft }

    trait :published do
      status { :published }
    end
  end
end
```

### Model Spec
```ruby
# spec/models/item_spec.rb
RSpec.describe Item, type: :model do
  subject(:item) { build(:item) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }
  it { is_expected.to belong_to(:user) }

  describe "#published?" do
    it "returns true when status is published" do
      item = build(:item, :published)
      expect(item).to be_published
    end
  end
end
```

### Request Spec
```ruby
# spec/requests/items_spec.rb
RSpec.describe "Items", type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:item, user: user) }

  before { sign_in user }

  describe "GET /items" do
    it "returns http success" do
      get items_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /items" do
    let(:valid_params) { { item: { title: "My Item", status: "draft" } } }

    it "creates an item and redirects" do
      expect {
        post items_path, params: valid_params
      }.to change(Item, :count).by(1)

      expect(response).to redirect_to(Item.last)
    end

    it "renders form with errors on invalid params" do
      post items_path, params: { item: { title: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
```

## Environment Variables
```bash
# .env (use dotenv-rails gem)
DATABASE_URL=postgres://user:pass@localhost:5432/myapp_development
REDIS_URL=redis://localhost:6379/0

SECRET_KEY_BASE=your-secret-key-base
RAILS_MASTER_KEY=your-master-key

# External services
SMTP_ADDRESS=smtp.example.com
SMTP_USERNAME=user
SMTP_PASSWORD=pass
```

## Key Files
| Purpose | File |
|---------|------|
| Routes | `config/routes.rb` |
| Application config | `config/application.rb` |
| Database schema | `db/schema.rb` |
| Test helpers | `spec/rails_helper.rb` |
| FactoryBot | `spec/factories/` |

## Commands
```bash
bin/rails server                    # Start dev server (localhost:3000)
bin/rails server -e production      # Start in production mode
bundle exec sidekiq                 # Start background job worker

bin/rails generate model Item title:string status:integer user:references
bin/rails generate controller Items index show new edit
bin/rails generate migration AddIndexToItems

bin/rails db:migrate                # Apply pending migrations
bin/rails db:migrate:status         # Show migration status
bin/rails db:rollback               # Undo last migration
bin/rails db:seed                   # Run db/seeds.rb
bin/rails db:reset                  # Drop, create, migrate, seed

bundle exec rspec                   # Run all tests
bundle exec rspec spec/models/      # Run model specs
bundle exec rspec spec/requests/    # Run request specs
bundle exec rspec --format documentation  # Verbose output

bundle exec rubocop                 # Lint all Ruby files
bundle exec rubocop -a              # Auto-fix safe offenses
bundle exec rubocop -A              # Auto-fix all offenses
```

## Code Style

### Ruby Conventions
- Follow Rubocop rules (configured in `.rubocop.yml`)
- Use `before_action` callbacks for common setup
- Keep controllers thin — move business logic to models or service objects

### Rails Conventions
- One migration per logical change; never edit existing migrations
- Use `scope` for reusable query building blocks
- Use `dependent: :destroy` or `dependent: :nullify` on all `has_many` associations
- Prefer `update!` / `save!` in background jobs (raise on failure rather than silently fail)

---

## Notes
[Any additional project-specific notes, gem choices, or deployment details]

## Resources
- [Rails Guides](https://guides.rubyonrails.org/)
- [Hotwire Documentation](https://hotwired.dev/)
- [RSpec Rails](https://rspec.info/documentation/)
- [Sidekiq Wiki](https://github.com/sidekiq/sidekiq/wiki)
- [Rubocop Rails](https://github.com/rubocop/rubocop-rails)
