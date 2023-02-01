defmodule RepositoryWeb.Router do
  use RepositoryWeb, :router

  import PhxLiveStorybook.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RepositoryWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", RepositoryWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/organizations", OrganizationLive.Index, :index
    live "/organizations/new", OrganizationLive.Index, :new
    live "/organizations/:id/edit", OrganizationLive.Index, :edit
    live "/organizations/:id", OrganizationLive.Show, :show
    live "/organizations/:id/show/edit", OrganizationLive.Show, :edit

    scope "/organizations/:organization_id" do
      live "/inventory_pools", InventoryPoolLive.Index, :index
      live "/inventory_pools/new", InventoryPoolLive.Index, :new
      live "/inventory_pools/:id/edit", InventoryPoolLive.Index, :edit
      live "/inventory_pools/:id", InventoryPoolLive.Show, :show
      live "/inventory_pools/:id/show/edit", InventoryPoolLive.Show, :edit

      live "/item_categories", ItemCategoryLive.Index, :index
      live "/item_categories/new", ItemCategoryLive.Index, :new
      live "/item_categories/:id/edit", ItemCategoryLive.Index, :edit
      live "/item_categories/:id", ItemCategoryLive.Show, :show
      live "/item_categories/:id/show/edit", ItemCategoryLive.Show, :edit

      live "/items", ItemLive.Index, :index
      live "/items/new", ItemLive.Index, :new
      live "/items/:id/edit", ItemLive.Index, :edit
      live "/items/:id", ItemLive.Show, :show
      live "/items/:id/show/edit", ItemLive.Show, :edit

      live "/warehouses", WarehouseLive.Index, :index
      live "/warehouses/new", WarehouseLive.Index, :new
      live "/warehouses/:id/edit", WarehouseLive.Index, :edit
      live "/warehouses/:id", WarehouseLive.Show, :show
      live "/warehouses/:id/show/edit", WarehouseLive.Show, :edit
    end

    live_storybook("/storybook", backend_module: RepositoryWeb.Storybook)
  end

  # Other scopes may use custom stacks.
  # scope "/api", RepositoryWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:repository, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RepositoryWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
