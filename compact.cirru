
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |comp-container $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} $ :content "\""
                div
                  {} $ :class-name (str-spaced css/global css/row)
                  comp-nav store
                  when dev? $ comp-reel (>> states :reel) reel ({})
        |comp-nav $ %{} :CodeEntry (:doc |)
          :code $ quote
            defcomp comp-nav (store)
              let
                  tab $ :tab store
                  show-tabs? $ and (not hide-tabs?) (:show-tabs? store)
                div
                  {} $ :class-name style-nav
                  if (not hide-tabs?)
                    list-> ({})
                      -> tabs $ map
                        fn (pair)
                          let
                              t $ nth pair 0
                              name $ nth pair 1
                            [] t $ div
                              {}
                                :class-name $ str-spaced style-tab css/font-fancy!
                                :on-click $ fn (e d!)
                                  d! $ :: :tab t (nth pair 2)
                                :style $ if (= tab t)
                                  {} $ :color :white
                              <> name
        |style-nav $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-nav $ {}
              "\"&" $ {} (:position :absolute) (:top 12)
        |style-tab $ %{} :CodeEntry (:doc |)
          :code $ quote
            defstyle style-tab $ {}
              "\"&" $ {} (:line-height "\"1.4") (:margin-top 2) (:padding "\"0 8px") (:width :fit-content)
                :color $ hsl 0 0 100 0.5
                :cursor :pointer
                :transition-duration "\"200ms"
                :border-radius "\"4px"
                :background-color $ hsl 0 0 0 0.2
              "\"&:hover" $ {}
                :background-color $ hsl 0 0 0 0.5
                :color :white
        |tabs $ %{} :CodeEntry (:doc |)
          :code $ quote
            def tabs $ [] (:: :cubic-fire "\"Cubic Fire" :dark) (:: :quaternion-fractal "\"Quaternion Fractal" :dark) (:: :complex-fractal "\"Complex Fractal" :dark) (:: :space-fractal "\"Space Fractal" :dark) (:: :sphere-fractal "\"Sphere Fractal" :dark) (:: :slow-fractal "\"Slow Fractal" :dark) (:: :orbits "\"Orbits" :dark) (:: :stars "\"Stars" :dark) (:: :rings "\"Rings" :dark) (:: :circles "\"Circles" :dark) (:: :kaleidoscope "\"Kaleidoscope" :dark) (:: :image "\"Image" :dark)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require (respo-ui.css :as css)
            respo.css :refer $ defstyle
            respo.util.format :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input list->
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev? hide-tabs?
    |app.config $ %{} :FileEntry
      :defs $ {}
        |dev? $ %{} :CodeEntry (:doc |)
          :code $ quote
            def dev? $ = "\"dev" (get-env "\"mode" "\"release")
        |hide-tabs? $ %{} :CodeEntry (:doc |)
          :code $ quote
            def hide-tabs? $ = "\"true" (get-env "\"hide-tabs" "\"false")
        |interval $ %{} :CodeEntry (:doc |)
          :code $ quote
            def interval $ w-js-log
              parse-float $ get-env "\"interval" "\"40"
        |site $ %{} :CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:storage-key "\"workflow")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.config)
    |app.main $ %{} :FileEntry
      :defs $ {}
        |*compute-shader $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *compute-shader nil)
        |*raf $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *raf 0)
        |*reel $ %{} :CodeEntry (:doc |)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
        |*timeout $ %{} :CodeEntry (:doc |)
          :code $ quote (defatom *timeout 0)
        |canvas $ %{} :CodeEntry (:doc |)
          :code $ quote
            def canvas $ js/document.querySelector "\"canvas"
        |dispatch! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op)
              when
                and config/dev? $ not= op :states
                js/console.log "\"Dispatch:" op
              solublejs/clearPointsBuffer
              reset! *reel $ reel-updater updater @*reel op
        |get-app $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn get-app (tab)
              case-default tab
                do (js/console.warn "\"Unknown tab" tab) cubicFireConfigs
                :cubic-fire cubicFireConfigs
                :quaternion-fractal quaternionFractalConfigs
                :complex-fractal complexFractalConfigs
                :space-fractal spaceFractalConfigs
                :sphere-fractal sphereFractalConfigs
                :slow-fractal slowFractalConfigs
                :orbits orbitsConfigs
                :stars stars/configs
                :rings rings/configs
                :circles circles/configs
                :kaleidoscope kaleidoscopeConfigs
                :image imageConfigs
        |load-textures! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn load-textures! (device) (hint-fn async)
              let
                  img-tiye $ solublejs/loadImageAsTexture device "\"https://cdn.tiye.me/logo/tiye.jpg"
                  img-candy $ solublejs/loadImageAsTexture device "\"https://cos-sh.tiye.me/cos-up/c7367e21405d602c5ef5a8c55c35d512/candy.jpeg"
                  img-bubbles $ solublejs/loadImageAsTexture device "\"https://cos-sh.tiye.me/cos-up/20b39957d952bd189e4253369db30335/pasted-2024-04-17T17:00:49.301Z.png"
                  img-rugs $ solublejs/loadImageAsTexture device "\"https://cos-sh.tiye.me/cos-up/ceec218462f81744323e22dd2d04e94b/pasted-2024-04-17T17:12:29.234Z.png"
                js-set (.!deref solublejs/atomSharedTextures) "\"tiye" $ js-await img-tiye
                js-set (.!deref solublejs/atomSharedTextures) "\"candy" $ js-await img-candy
                js-set (.!deref solublejs/atomSharedTextures) "\"bubbles" $ js-await img-bubbles
                js-set (.!deref solublejs/atomSharedTextures) "\"rugs" $ js-await img-rugs
        |loop-paint! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn loop-paint! () (solublejs/callFramePaint)
              if (> config/interval 10)
                reset! *timeout $ flipped js/setTimeout config/interval
                  fn () $ reset! *raf
                    js/requestAnimationFrame $ fn (t) (loop-paint!)
                reset! *raf $ js/requestAnimationFrame
                  fn (t) (loop-paint!)
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! () (hint-fn async)
              println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
              if config/dev? $ load-console-formatter!
              let
                  ret $ js-await (solublejs/initializeContext)
                if
                  = :image $ -> @*reel :store :tab
                  js-await $ load-textures! (.-device ret)
                  do
                    load-textures! $ .-device ret
                    , nil
              render-app!
              loop-paint!
              solublejs/resetCanvasHeight canvas
              js/window.addEventListener "\"resize" $ fn (event) (solublejs/resetCanvasHeight canvas) (solublejs/paintSolubleTree)
              solublejs/loadGamepadControl $ fn (events)
                if-let
                  f $ .-onButtonEvent (.-value atomSolubleTree)
                  f events
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
              js/window.addEventListener |visibilitychange $ fn (event)
                if (= "\"hidden" js/document.visibilityState) (persist-storage!)
              flipped js/setInterval 60000 persist-storage!
              ; let
                  raw $ js/localStorage.getItem (:storage-key config/site)
                when (some? raw)
                  dispatch! $ :: :hydrate-storage (parse-cirru-edn raw)
              println "|App started."
        |mount-target $ %{} :CodeEntry (:doc |)
          :code $ quote
            def mount-target $ js/document.querySelector |.app
        |persist-storage! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! ()
              println "\"Saved at" $ .!toISOString (new js/Date)
              js/localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ :store @*reel
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (solublejs/clearPointsBuffer) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                js/cancelAnimationFrame @*raf
                render-app!
                loop-paint!
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! "\"ok~" "\"Ok"
              hud! "\"error" build-errors
        |render-app! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn render-app! ()
              let
                  tab $ :tab (:store @*reel)
                  app-config $ get-app tab
                .!initPointsBuffer app-config
                solublejs/renderSolubleTree app-config
              render! mount-target (comp-container @*reel) dispatch!
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.main $ :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            "\"./calcit.build-errors" :default build-errors
            "\"bottom-tip" :default hud!
            "\"../src/index" :as solublejs
            "\"../src/apps/cubic-fire" :refer $ cubicFireConfigs
            "\"../src/apps/quaternion-fractal" :refer $ quaternionFractalConfigs
            "\"../src/apps/complex-fractal" :refer $ complexFractalConfigs
            "\"../src/apps/space-fractal" :refer $ spaceFractalConfigs
            "\"../src/apps/sphere-fractal" :refer $ sphereFractalConfigs
            "\"../src/apps/slow-fractal" :refer $ slowFractalConfigs
            "\"../src/apps/orbits" :refer $ orbitsConfigs
            "\"../src/apps/kaleidoscope" :refer $ kaleidoscopeConfigs
            "\"../src/apps/image" :refer $ imageConfigs
            "\"../src/apps/stars" :as stars
            "\"../src/apps/rings" :as rings
            "\"../src/apps/circles" :as circles
            "\"../src/global" :refer $ atomSolubleTree
    |app.schema $ %{} :FileEntry
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |)
          :code $ quote
            def store $ {}
              :tab $ turn-tag (get-env "\"tab" "\"kaleidoscope")
              :states $ {}
                :cursor $ []
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                  :states cursor s
                  update-states store cursor s
                (:tab t theme) (assoc store :tab t)
                (:hydrate-storage data) data
                _ $ do (eprintln "\"unknown op:" op) store
      :ns $ %{} :CodeEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
