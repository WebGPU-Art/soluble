
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |reel.calcit/ |js-ffi/
      :type-slots $ {} $ :dispatch-op 'app.schema/Op
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel on-control!)
            let
                store $ :store reel
              div
                {} $ :class-name $ str-spaced css/global css/row
                comp-nav store
                if dev?
                  Some $ comp-typed-reel ({}) reel ({}) on-control!
                  , None
          :examples $ []
          :schema $ quote $ Fn (typed/State schema/Op schema/Store)
            Fn typed/Control $ -> Unit
            -> respo.schema/Component
        'comp-nav $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-nav (store)
            let
                tab $ :tab store
              div
                {} $ :class-name style-nav-wrapper
                if (not hide-tabs?)
                  Some $ div
                    {} $ :class-name style-nav
                    list->
                      {} $ :style $ {} (:display :flex) (:flex-direction :row) (:gap 4) (:align-items :flex-start)
                      -> schema/tab-groups $ map $ fn (group)
                        let
                            gname $ :name group
                            gtabs $ :tabs group
                          [] gname $ div
                            {} $ :class-name style-nav-col
                            div
                              {} $ :class-name style-group-header
                              <> gname
                            list-> ({})
                              -> gtabs $ map $ fn (pair)
                                let
                                    t $ :id pair
                                    name $ :name pair
                                  [] t $ div
                                    {}
                                      :class-name $ str-spaced style-tab css/font-fancy!
                                      :on-click $ fn (e d!)
                                        hint-fn $ Fn respo.schema/RespoEvent
                                          Fn schema/Op $ -> Unit
                                          -> Unit
                                        d! $ schema/Op :tab t
                                      :style $ if (= tab t)
                                        {} $ :color :white
                                        {}
                                    <> name
                  , None
          :examples $ []
          :schema $ quote $ Fn schema/Store (-> respo.schema/Component)
        'style-group-header $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-group-header
            {} $ |& $ {} (:font-size 10)
              :color $ hsl 0 0 100 0.45
              :padding "|2px 8px 4px"
              :text-transform :uppercase
              :letter-spacing 1
          :examples $ []
          :schema $ quote String
        'style-nav $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav
            {} $ |& $ {} (:display :flex) (:flex-direction :row) (:gap 4) (:padding 8) (:align-items :flex-start)
              :background-color $ hsl 0 0 0 0.5
              :border-radius |4px
          :examples $ []
          :schema $ quote String
        'style-nav-col $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav-col
            {} $ |& $ {} (:display :flex) (:flex-direction :column) (:min-width 120)
          :examples $ []
          :schema $ quote String
        'style-nav-wrapper $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav-wrapper
            {}
              |& $ {} (:position :absolute) (:top 0) (:left 0) (:opacity 0) (:transition-duration |300ms) (:transition-property |opacity) (:z-index 10)
              |&:hover $ {} $ :opacity 1
          :examples $ []
          :schema $ quote String
        'style-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-tab
            {}
              |& $ {} (:line-height |1.4) (:margin-top 2) (:padding "|0 8px") (:width :fit-content)
                :color $ hsl 0 0 100 0.5
                :cursor :pointer
                :transition-duration |200ms
                :border-radius |4px
                :background-color $ hsl 0 0 0 0.2
              |&:hover $ {}
                :background-color $ hsl 0 0 0 0.5
                :color :white
          :examples $ []
          :schema $ quote String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.css :as css)
            respo.css :refer $ defstyle
            respo.util.format :refer $ hsl
            respo.core :refer $ defcomp defeffect <> div button textarea span input list->
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-typed-reel
            reel.typed :as typed
            app.config :refer $ dev? hide-tabs?
            app.schema :as schema
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'default-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def default-tab
            to-tag $ .unwrap-or (get-env |tab) |inversion-circles
          :examples $ []
          :schema $ quote Tag
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ .unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ quote Bool
        'hide-tabs? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def hide-tabs?
            = |true $ .unwrap-or (get-env |hide-tabs) |false
          :examples $ []
          :schema $ quote Bool
        'interval $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def interval 40
          :examples $ []
          :schema $ quote Number
        'resource-base-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def resource-base-url (get-env |resource-base-url)
          :examples $ []
          :schema $ quote $ Option String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ quote $ Ref (typed/State schema/Op schema/Store)
        'current-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn current-tab ()
            :tab $ :store @*reel
          :examples $ []
          :schema $ quote $ Fn (-> Tag)
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op) (dispatch-resolved! op)
          :examples $ []
          :schema $ quote $ Fn schema/Op (-> Unit)
        'dispatch-resolved! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch-resolved! (op)
            reset! *reel $ match op
              (reel.typed/Control control) (typed/apply-control updater @*reel control)
              (app.schema/Op action)
                typed/record-op updater @*reel action (shared/random-uuid) (shared/now-ms)
            , &unit
          :examples $ []
          :schema $ quote $ Fn schema/ResolvedOp (-> Unit)
        'get-tab-from-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-tab-from-url ()
            let
                raw $ runtime/url-tab
              .map
                schema/find-tab $ to-tag raw
                fn (tab) (:id tab)
          :examples $ []
          :schema $ quote $ Fn
            -> $ Option Tag
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            match (get-tab-from-url)
              (:some tab)
                reset! *reel $ struct-with @*reel
                  :base $ struct-with schema/store $ :tab tab
                  :store $ struct-with schema/store $ :tab tab
              (:none) &unit
            when config/dev? $ load-console-formatter!
            add-watch! *reel :changes on-change!
            when config/dev? $ listen-devtools! |k on-control!
            println "|Running mode:" $ if config/dev? |dev |release
            runtime/initialize!
              to-string $ current-tab
              , config/interval replace-url render-app! report-error!
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'on-change! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-change! (reel previous) (render-app!)
            when
              not=
                :tab $ :store reel
                :tab $ :store previous
              let
                  tab $ to-string $ :tab (:store reel)
                browser/history-replace-state! $ str |?tab= tab
                runtime/select-tab! tab
            , &unit
          :examples $ []
          :schema $ quote $ Fn (typed/State schema/Op schema/Store) (typed/State schema/Op schema/Store) (-> Unit)
        'on-control! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn on-control! (control) (dispatch-resolved! control) &unit
          :examples $ []
          :schema $ quote $ Fn typed/Control (-> Unit)
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                reset! *reel $ typed/refresh updater @*reel schema/store
                add-watch! *reel :changes on-change!
                render-app!
                runtime/reload! $ to-string $ current-tab
                hud! |ok~ |Ok
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ quote $ Fn (-> Unit) (:features :js-ffi)
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with!
              .unwrap $ dom/query-selector |.app
              fn () $ comp-container @*reel on-control!
              , dispatch!
          :examples $ []
          :schema $ quote $ Fn (-> Unit)
        'replace-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn replace-url (url)
            if (.some? config/resource-base-url)
              str (.unwrap config/resource-base-url) |/ $ .unwrap-or
                last $ split url |/
                , |
              , url
          :examples $ []
          :schema $ quote $ Fn String (-> String)
        'report-error! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn report-error! (message) (eprintln message) (hud! |error message) (render-app!) &unit
          :examples $ []
          :schema $ quote $ Fn String (-> Unit) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            respo.ffi.browser :as dom
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.typed :as typed
            reel.util :refer $ listen-devtools!
            js-ffi.browser :as browser
            js-ffi.shared :as shared
            app.runtime :as runtime
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
    'app.runtime $ %{} 'FileEntry
      :defs $ {}
        'RuntimeAPI $ %{} 'CodeEntry (:doc |)
          :code $ quote $ deftrait RuntimeAPI
            .initialize! $ Fn app.runtime/RuntimeAPI String Number
              Fn String $ -> String
              Fn $ -> Unit
              Fn String $ -> Unit
              -> Unit
            .select-tab! $ Fn app.runtime/RuntimeAPI String $ -> Unit
            .reload! $ Fn app.runtime/RuntimeAPI String $ -> Unit
            .get-url-tab $ Fn app.runtime/RuntimeAPI $ -> String
          :examples $ []
          :ffi $ {} (:backend :js) (:kind :external-object) (:target :browser)
            :names $ {} (:get-url-tab |getUrlTab) (:initialize! |initialize) (:reload! |reload) (:select-tab! |selectTab)
          :schema $ quote Trait
        'api $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn api () (js-cast runtime 'RuntimeAPI)
          :examples $ []
          :schema $ quote $ Fn (-> RuntimeAPI) (:features :js-ffi)
        'initialize! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn initialize! (tab interval transform-url ready! failed!)
            let
                host $ api
              host .initialize! tab interval transform-url ready! failed!
            , &unit
          :examples $ []
          :schema $ quote $ Fn String Number
            Fn String $ -> String
            Fn $ -> Unit
            Fn String $ -> Unit
            -> Unit
            :features :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! (tab)
            let
                host $ api
              host .reload! tab
            , &unit
          :examples $ []
          :schema $ quote $ Fn String (-> Unit) (:features :js-ffi)
        'select-tab! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn select-tab! (tab)
            let
                host $ api
              host .select-tab! tab
            , &unit
          :examples $ []
          :schema $ quote $ Fn String (-> Unit) (:features :js-ffi)
        'url-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn url-tab ()
            let
                host $ api
              host .get-url-tab
          :examples $ []
          :schema $ quote $ Fn (-> String) (:features :js-ffi)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.runtime
          :require $ |../src/calcit-runtime.mts :default runtime
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op (:tab Tag)
          :examples $ []
          :schema $ quote EnumDef
        'ResolvedOp $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defunion ResolvedOp Op reel.typed/Control
          :examples $ []
          :schema $ quote UnionDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store (:tab Tag)
          :examples $ []
          :schema $ quote StructDef
        'Tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Tab (:id Tag) (:name String) (:theme Tag)
          :examples $ []
          :schema $ quote StructDef
          :tests $ [] $ %{} 'TestEntry (:name |lookup-preserves-names-and-themes)
            :code $ quote $ let
                tab $ .unwrap $ find-tab :inversion-circles
              assert= "|Inversion Circles" $ :name tab
              assert= :dark $ :theme tab
              assert= :inversion-circles $ :id tab
            :tags $ #{} :unit
        'TabGroup $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct TabGroup (:name String)
            :tabs $ List app.schema/Tab
          :examples $ []
          :schema $ quote StructDef
          :tests $ [] $ %{} 'TestEntry (:name |all-navigation-tabs-have-unique-identities)
            :code $ quote $ do
              assert= 5 $ .len tab-groups
              assert= 59 $ .len tabs
              assert= (.len tabs)
                .len $ .to-set $ .map tabs
                  fn (tab) (:id tab)
              assert= true $ .some? $ find-tab :gravity-spheres
              assert= true $ .none? $ find-tab :not-an-app
            :tags $ #{} :unit
        'find-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn find-tab (id)
            find tabs $ fn (tab)
              = id $ :id tab
          :examples $ []
          :schema $ quote $ Fn Tag
            -> $ Option Tab
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store (Store :tab default-tab)
          :examples $ []
          :schema $ quote Store
        'tab-groups $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def tab-groups
            []
              TabGroup :name |Fractals :tabs $ [] (Tab :id :cubic-fire :name "|Cubic Fire" :theme :dark) (Tab :id :quaternion-fractal :name "|Quaternion Fractal" :theme :dark) (Tab :id :complex-fractal :name "|Complex Fractal" :theme :dark) (Tab :id :newton-fractal :name "|Newton Fractal" :theme :dark) (Tab :id :newton-cosh-fractal :name "|Newton Cosh Fractal" :theme :dark) (Tab :id :space-fractal :name "|Space Fractal" :theme :dark) (Tab :id :sphere-fractal :name "|Sphere Fractal" :theme :dark) (Tab :id :slow-fractal :name "|Slow Fractal" :theme :dark) (Tab :id :apollonian-twist :name "|Apollonian Twist" :theme :dark) (Tab :id :apollonian-mobius :name "|Apollonian Mobius" :theme :dark) (Tab :id :apollonian-helix :name "|Apollonian Helix" :theme :dark) (Tab :id :apollonian-mobius-helix :name "|Apollonian Mobius Helix" :theme :dark)
              TabGroup :name |Effects :tabs $ [] (Tab :id :orbits :name |Orbits :theme :dark) (Tab :id :stars :name |Stars :theme :dark) (Tab :id :rings :name |Rings :theme :dark) (Tab :id :circles :name |Circles :theme :dark) (Tab :id :kaleidoscope :name |Kaleidoscope :theme :dark) (Tab :id :image :name |Image :theme :dark) (Tab :id :clocking :name |Clocking :theme :dark) (Tab :id :ripple :name |Ripple :theme :dark) (Tab :id :dots-clock :name "|Dots Clock" :theme :dark) (Tab :id :inversion-circles :name "|Inversion Circles" :theme :dark)
              TabGroup :name |Mirrors :tabs $ [] (Tab :id :surround-mirror :name "|Surround Mirror" :theme :dark) (Tab :id :kaleidoscope-mirror :name "|Kaleidoscope Mirror" :theme :dark) (Tab :id :parallel-mirror :name "|Parallel Mirror" :theme :dark) (Tab :id :sphere-mirror :name "|Sphere Mirror" :theme :dark) (Tab :id :packing-sphere-mirror :name "|Packing Sphere Mirror" :theme :dark) (Tab :id :orbit-spheres-mirror :name "|Orbit Spheres Mirror" :theme :dark) (Tab :id :gravity-spheres :name "|Gravity Spheres" :theme :dark) (Tab :id :pulse-spheres :name "|Pulse Spheres" :theme :dark) (Tab :id :gravity-cubes :name "|Gravity Cubes" :theme :dark) (Tab :id :gravity-octahedron :name "|Gravity Octahedron" :theme :dark) (Tab :id :hollow-mirror :name "|Hollow Mirror" :theme :dark) (Tab :id :box-mirror :name "|Box Mirror" :theme :dark) (Tab :id :pyramid-mirror :name "|Pyramid Mirror" :theme :dark)
              TabGroup :name |Polyhedra :tabs $ [] (Tab :id :tetrahedron-mirror :name "|Tetrahedron Mirror" :theme :dark) (Tab :id :tetrahedron-parabola-mirror :name "|Tetrahedron Parabola" :theme :dark) (Tab :id :tetrahedron-arc-mirror :name "|Tetrahedron Arc" :theme :dark) (Tab :id :cube-parabola-mirror :name "|Cube Parabola" :theme :dark) (Tab :id :octahedron-mirror :name "|Octahedron Mirror" :theme :dark) (Tab :id :octahedron-parabola-mirror :name "|Octahedron Parabola" :theme :dark) (Tab :id :truncated-octahedron-mirror :name "|Truncated Octahedron" :theme :dark) (Tab :id :cuboctahedron-mirror :name "|Cuboctahedron Mirror" :theme :dark) (Tab :id :prism-mirror :name "|Prism Mirror" :theme :dark) (Tab :id :hex-prism-mirror :name "|Hex Prism Mirror" :theme :dark) (Tab :id :icosahedron-mirror :name "|Icosahedron Mirror" :theme :dark) (Tab :id :wedge-mirror :name "|Wedge Mirror" :theme :dark) (Tab :id :rhombohedron-mirror :name "|Rhombohedron Mirror" :theme :dark) (Tab :id :rhombic-mirror :name "|Rhombic Mirror" :theme :dark) (Tab :id :rhombic-dodecahedron-diagonals-mirror :name "|Rhombic Dodecahedron Diagonals" :theme :dark) (Tab :id :rhombic-dodecahedron-parabola-mirror :name "|Rhombic Dodecahedron Parabola" :theme :dark) (Tab :id :rhombic-dodecahedron-rotating-mirror :name "|Rhombic Dodecahedron Rotating" :theme :dark) (Tab :id :rt-mirror :name "|Rhombic Triacontahedron" :theme :dark) (Tab :id :deltoidal-icositetrahedron-mirror :name "|Deltoidal Icositetrahedron" :theme :dark) (Tab :id :dodecahedron-mirror :name "|Dodecahedron Mirror" :theme :dark) (Tab :id :crystal-refraction :name "|Crystal Refraction" :theme :dark)
              TabGroup :name |Pair :tabs $ [] (Tab :id :twin-pulse :name "|Twin Pulse" :theme :dark) (Tab :id :twin-cubes :name "|Twin Cubes" :theme :dark) (Tab :id :tetra-octa :name |Tetra-Octa :theme :dark)
          :examples $ []
          :schema $ quote $ List TabGroup
        'tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def tabs
            .flat-map tab-groups $ fn (group) (:tabs group)
          :examples $ []
          :schema $ quote $ List Tab
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
          :require $ app.config :refer $ default-tab
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op $
              :tab tab
              struct-with store $ :tab tab
          :examples $ []
          :schema $ quote $ Fn app.schema/Store app.schema/Op String Number (-> app.schema/Store)
          :tests $ [] $ %{} 'TestEntry (:name |tab-update-selects-renderer)
            :code $ quote $ let
                selected $ updater app.schema/store (app.schema/Op :tab :rings) |tab 1
              assert= :rings $ :tab selected
            :tags $ #{} :unit
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
