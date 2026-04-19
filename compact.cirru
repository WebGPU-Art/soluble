
{} (:about "|Machine-generated snapshot. AI AGENTS: never edit this file directly — changes will be overwritten on recompile. Inspect via `cr query`; modify via `cr edit` / `cr tree`. MANDATORY first step: run `cr docs agents --full`.") (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |comp-container $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} $ :content |
                div
                  {} $ :class-name (str-spaced css/global css/row)
                  comp-nav store
                  when dev? $ comp-reel (>> states :reel) reel ({})
          :examples $ []
        |comp-nav $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defcomp comp-nav (store)
              let
                  tab $ :tab store
                div
                  {} $ :class-name style-nav-wrapper
                  when (not hide-tabs?)
                    div
                      {} $ :class-name style-nav
                      list->
                        {} $ :style
                          {} (:display :flex) (:flex-direction :row) (:gap 4) (:align-items :flex-start)
                        -> tab-groups $ map
                          fn (group)
                            let
                                gname $ nth group 0
                                gtabs $ nth group 1
                              [] gname $ div
                                {} $ :class-name style-nav-col
                                div
                                  {} $ :class-name style-group-header
                                  <> gname
                                list-> ({})
                                  -> gtabs $ map
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
          :examples $ []
        |style-group-header $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-group-header $ {}
              |& $ {} (:font-size 10)
                :color $ hsl 0 0 100 0.45
                :padding "|2px 8px 4px"
                :text-transform :uppercase
                :letter-spacing 1
          :examples $ []
        |style-nav $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-nav $ {}
              |& $ {} (:display :flex) (:flex-direction :row) (:gap 4) (:padding 8) (:align-items :flex-start)
                :background-color $ hsl 0 0 0 0.5
                :border-radius |4px
          :examples $ []
        |style-nav-col $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-nav-col $ {}
              |& $ {} (:display :flex) (:flex-direction :column) (:min-width 120)
          :examples $ []
        |style-nav-wrapper $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-nav-wrapper $ {}
              |& $ {} (:position :absolute) (:top 0) (:left 0) (:opacity 0) (:transition-duration |300ms) (:transition-property |opacity) (:z-index 10)
              |&:hover $ {} (:opacity 1)
          :examples $ []
        |style-tab $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-tab $ {}
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
        |tab-groups $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def tab-groups $ []
              [] |Fractals $ [] (:: :cubic-fire "|Cubic Fire" :dark) (:: :quaternion-fractal "|Quaternion Fractal" :dark) (:: :complex-fractal "|Complex Fractal" :dark) (:: :newton-fractal "|Newton Fractal" :dark) (:: :newton-cosh-fractal "|Newton Cosh Fractal" :dark) (:: :space-fractal "|Space Fractal" :dark) (:: :sphere-fractal "|Sphere Fractal" :dark) (:: :slow-fractal "|Slow Fractal" :dark)
              [] |Effects $ [] (:: :orbits |Orbits :dark) (:: :stars |Stars :dark) (:: :rings |Rings :dark) (:: :circles |Circles :dark) (:: :kaleidoscope |Kaleidoscope :dark) (:: :image |Image :dark) (:: :clocking |Clocking :dark) (:: :ripple |Ripple :dark) (:: :dots-clock "|Dots Clock" :dark) (:: :inversion-circles "|Inversion Circles" :dark)
              [] |Mirrors $ [] (:: :surround-mirror "|Surrond Mirror" :dark) (:: :kaleidoscope-mirror "|Kaleidoscope Mirror" :dark) (:: :parallel-mirror "|Parallel Mirror" :dark) (:: :sphere-mirror "|Sphere Mirror" :dark) (:: :orbit-spheres-mirror "|Orbit Spheres Mirror" :dark) (:: :hollow-mirror "|Hollow Mirror" :dark) (:: :box-mirror "|Box Mirror" :dark) (:: :pyramid-mirror "|Pyramid Mirror" :dark)
              [] |Polyhedra $ [] (:: :tetrahedron-mirror "|Tetrahedron Mirror" :dark) (:: :octahedron-mirror "|Octahedron Mirror" :dark) (:: :prism-mirror "|Prism Mirror" :dark) (:: :hex-prism-mirror "|Hex Prism Mirror" :dark) (:: :icosahedron-mirror "|Icosahedron Mirror" :dark) (:: :wedge-mirror "|Wedge Mirror" :dark) (:: :rhombic-mirror "|Rhombic Mirror" :dark) (:: :rt-mirror "|Rhombic Triacontahedron" :dark) (:: :dodecahedron-mirror "|Dodecahedron Mirror" :dark)
          :examples $ []
        |tabs $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def tabs $ [] (:: :cubic-fire "|Cubic Fire" :dark) (:: :quaternion-fractal "|Quaternion Fractal" :dark) (:: :complex-fractal "|Complex Fractal" :dark) (:: :newton-fractal "|Newton Fractal" :dark) (:: :newton-cosh-fractal "|Newton Cosh Fractal" :dark) (:: :space-fractal "|Space Fractal" :dark) (:: :sphere-fractal "|Sphere Fractal" :dark) (:: :slow-fractal "|Slow Fractal" :dark) (:: :orbits |Orbits :dark) (:: :stars |Stars :dark) (:: :rings |Rings :dark) (:: :circles |Circles :dark) (:: :kaleidoscope |Kaleidoscope :dark) (:: :image |Image :dark) (:: :clocking |Clocking :dark) (:: :ripple |Ripple :dark) (:: :surround-mirror "|Surrond Mirror" :dark) (:: :kaleidoscope-mirror "|Kaleidoscope Mirror" :dark) (:: :parallel-mirror "|Parallel Mirror" :dark) (:: :sphere-mirror "|Sphere Mirror" :dark) (:: :orbit-spheres-mirror "|Orbit Spheres Mirror" :dark) (:: :hollow-mirror "|Hollow Mirror" :dark) (:: :box-mirror "|Box Mirror" :dark) (:: :pyramid-mirror "|Pyramid Mirror" :dark) (:: :tetrahedron-mirror "|Tetrahedron Mirror" :dark) (:: :octahedron-mirror "|Octahedron Mirror" :dark) (:: :prism-mirror "|Prism Mirror" :dark) (:: :hex-prism-mirror "|Hex Prism Mirror" :dark) (:: :icosahedron-mirror "|Icosahedron Mirror" :dark) (:: :wedge-mirror "|Wedge Mirror" :dark) (:: :rhombic-mirror "|Rhombic Mirror" :dark) (:: :rt-mirror "|Rhombic Triacontahedron" :dark) (:: :dodecahedron-mirror "|Dodecahedron Mirror" :dark) (:: :dots-clock "|Dots Clock" :dark) (:: :inversion-circles "|Inversion Circles" :dark)
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
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
        |dev? $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def dev? $ = |dev (get-env |mode |release)
          :examples $ []
        |hide-tabs? $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def hide-tabs? $ = |true (get-env |hide-tabs |false)
          :examples $ []
        |interval $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def interval $ w-js-log
              parse-float $ get-env |interval |40
          :examples $ []
        |resource-base-url $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def resource-base-url $ get-env |resource-base-url
          :examples $ []
        |site $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def site $ {} (:storage-key |workflow)
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.config)
    |app.img-counter $ %{} :FileEntry
      :defs $ {}
        |*counter $ %{} :CodeEntry (:doc "|0-8 slots for pictures") (:schema :dynamic)
          :code $ quote (defatom *counter 0)
          :examples $ []
        |img-slot! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn img-slot! () $ let
                ret @*counter
              if (< ret 8) (swap! *counter inc) (reset! *counter 0)
              , ret
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.img-counter)
    |app.main $ %{} :FileEntry
      :defs $ {}
        |*compute-shader $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote (defatom *compute-shader nil)
          :examples $ []
        |*raf $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote (defatom *raf 0)
          :examples $ []
        |*reel $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
        |*timeout $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote (defatom *timeout 0)
          :examples $ []
        |canvas $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def canvas $ js/document.querySelector |canvas
          :examples $ []
        |dispatch! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn dispatch! (op)
              hint-fn $ {} (:async true)
              when
                and config/dev? $ not= op :states
                js/console.log |Dispatch: op
              tag-match op
                  :tab t theme
                  do (js/cancelAnimationFrame @*raf) (js/clearTimeout @*timeout)
                    js-await $ solublejs/waitForRenderIdle
                    reset! *reel $ reel-updater updater @*reel op
                    loop-paint!
                _ $ reset! *reel (reel-updater updater @*reel op)
          :examples $ []
        |get-app $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn get-app (tab)
              case-default tab
                do (js/console.warn "|Unknown tab" tab) cubicFireConfigs
                :cubic-fire cubicFireConfigs
                :quaternion-fractal quaternionFractalConfigs
                :complex-fractal complexFractalConfigs
                :newton-fractal newtonFractalConfigs
                :newton-cosh-fractal newtonCoshFractalConfigs
                :space-fractal spaceFractalConfigs
                :sphere-fractal sphereFractalConfigs
                :slow-fractal slowFractalConfigs
                :orbits orbitsConfigs
                :stars stars/configs
                :rings rings/configs
                :circles circles/configs
                :kaleidoscope kaleidoscopeConfigs
                :kaleidoscope-mirror kaleidoscopeMirrorConfigs
                :clocking clockingConfigs
                :image imageConfigs
                :ripple rippleConfigs
                :surround-mirror surroundMirrorConfigs
                :parallel-mirror parallelMirrorConfigs
                :sphere-mirror sphereMirrorConfigs
                :orbit-spheres-mirror orbitSpheresMirrorConfigs
                :hollow-mirror hollowMirrorConfigs
                :box-mirror boxMirrorConfigs
                :pyramid-mirror pyramidMirrorConfigs
                :tetrahedron-mirror tetrahedronMirrorConfigs
                :octahedron-mirror octahedronMirrorConfigs
                :prism-mirror prismMirrorConfigs
                :hex-prism-mirror hexPrismMirrorConfigs
                :icosahedron-mirror icosahedronMirrorConfigs
                :wedge-mirror wedgeMirrorConfigs
                :rhombic-mirror rhombicMirrorConfigs
                :rt-mirror rtMirrorConfigs
                :dodecahedron-mirror dodecahedronMirrorConfigs
                :inversion-circles inversionCirclesConfigs
                :dots-clock dotsClockConfigs
          :examples $ []
        |load-textures! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn load-textures! (device)
              hint-fn $ {} (:async true)
              let
                  img-tiye $ solublejs/loadImageAsTexture device (replace-url |https://cdn.tiye.me/logo/tiye.jpg)
                  img-candy $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/c7367e21405d602c5ef5a8c55c35d512/candy.jpeg)
                  img-bubbles $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/20b39957d952bd189e4253369db30335/pasted-2024-04-17T17:00:49.301Z.png)
                  img-rugs $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/ceec218462f81744323e22dd2d04e94b/pasted-2024-04-17T17:12:29.234Z.png)
                  img-pigment $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/4a932a1d8eaf46b4d9d8ec07538e8ee1/pigment.jpg)
                  img-stripes $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/d090a685f03af9d31988a2a92b3b8a19/stripes.jpg)
                  img-circles $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/80e5932494210d46c600b402a029f973/circles.jpg)
                  img-sparks $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/3fd6b05f2f9b9a1985224ac39e7b3aee/sparks.jpg)
                  img-rhombic $ solublejs/loadImageAsTexture device (replace-url |https://cos-sh.tiye.me/cos-up/309de8ad40b61cb865b32adedf1b2dc4/rhombic-mirror.png)
                js-set (.!deref solublejs/atomSharedTextures) |tiye $ js-await img-tiye
                js-set (.!deref solublejs/atomSharedTextures) |candy $ js-await img-candy
                js-set (.!deref solublejs/atomSharedTextures) |bubbles $ js-await img-bubbles
                js-set (.!deref solublejs/atomSharedTextures) |rugs $ js-await img-rugs
                js-set (.!deref solublejs/atomSharedTextures) |stripes $ js-await img-stripes
                js-set (.!deref solublejs/atomSharedTextures) |pigment $ js-await img-pigment
                js-set (.!deref solublejs/atomSharedTextures) |circles $ js-await img-circles
                js-set (.!deref solublejs/atomSharedTextures) |sparks $ js-await img-sparks
                js-set (.!deref solublejs/atomSharedTextures) |yulan $ js-await img-rhombic
          :examples $ []
        |loop-paint! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn loop-paint! ()
              hint-fn $ {} (:async true)
              js-await $ solublejs/callFramePaint
              if (> config/interval 10)
                reset! *timeout $ flipped js/setTimeout config/interval
                  fn () $ reset! *raf
                    js/requestAnimationFrame $ fn (t) (loop-paint!)
                reset! *raf $ js/requestAnimationFrame
                  fn (t) (loop-paint!)
          :examples $ []
        |main! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn main! ()
              hint-fn $ {} (:async true)
              println "|Running mode:" $ if config/dev? |dev |release
              if config/dev? $ load-console-formatter!
              let
                  ret $ js-await (solublejs/initializeContext)
                  device $ .-device ret
                if
                  contains?
                    #{} :image :surround-mirror $ ; :sphere-mirror
                    -> @*reel :store :tab
                  do
                    js-await $ load-textures! device
                    js/window.addEventListener |keydown $ fn (event)
                      hint-fn $ {} (:async true)
                      js/console.log event
                      if
                        and
                          or (.-metaKey event) (.-ctrlKey event)
                          = |b $ .-key event
                        let
                            texture $ js-await (solublejs/loadImageFromInputEl device)
                            k $ img-slot!
                          js-set (.!deref solublejs/atomSharedTextures) k texture
                          js/console.log "|image added to slot" k
                  do (load-textures! device) nil
              render-app!
              loop-paint!
              solublejs/resetCanvasHeight canvas
              js/window.addEventListener |resize $ fn (event) (solublejs/resetCanvasHeight canvas) (solublejs/paintSolubleTree)
              solublejs/loadGamepadControl $ fn (events)
                if-let
                  f $ .-onButtonEvent (.-value atomSolubleTree)
                  f events
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
              js/window.addEventListener |visibilitychange $ fn (event)
                if (= |hidden js/document.visibilityState) (persist-storage!)
              ; flipped js/setInterval 60000 persist-storage!
              ; let
                  raw $ js/localStorage.getItem (:storage-key config/site)
                when (some? raw)
                  dispatch! $ :: :hydrate-storage (parse-cirru-edn raw)
              println "|App started."
          :examples $ []
        |mount-target $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def mount-target $ js/document.querySelector |.app
          :examples $ []
        |persist-storage! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn persist-storage! ()
              println "|Saved at" $ .!toISOString (new js/Date)
              js/localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ :store @*reel
          :examples $ []
        |reload! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                js/cancelAnimationFrame @*raf
                render-app!
                loop-paint!
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
        |render-app! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn render-app! ()
              let
                  tab $ :tab (:store @*reel)
                  app-config $ get-app tab
                solublejs/clearPointsBuffer
                .!initPointsBuffer app-config
                solublejs/renderSolubleTree app-config
              render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
        |replace-url $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn replace-url (url)
              if (some? config/resource-base-url)
                str config/resource-base-url |/ $ last (.split url |/)
                , url
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
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
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            |../src/index.mts :as solublejs
            |../src/apps/cubic-fire.mts :refer $ cubicFireConfigs
            |../src/apps/quaternion-fractal.mts :refer $ quaternionFractalConfigs
            |../src/apps/complex-fractal.mts :refer $ complexFractalConfigs
            |../src/apps/newton.mts :refer $ newtonFractalConfigs
            |../src/apps/newton-cosh.mts :refer $ newtonCoshFractalConfigs
            |../src/apps/space-fractal.mts :refer $ spaceFractalConfigs
            |../src/apps/sphere-fractal.mts :refer $ sphereFractalConfigs
            |../src/apps/slow-fractal.mts :refer $ slowFractalConfigs
            |../src/apps/orbits.mts :refer $ orbitsConfigs
            |../src/apps/kaleidoscope.mts :refer $ kaleidoscopeConfigs
            |../src/apps/kaleidoscope-mirror.mts :refer $ kaleidoscopeMirrorConfigs
            |../src/apps/image.mts :refer $ imageConfigs
            |../src/apps/stars.mts :as stars
            |../src/apps/rings.mts :as rings
            |../src/apps/circles.mts :as circles
            |../src/apps/clocking.mts :refer $ clockingConfigs
            |../src/apps/ripple.mts :refer $ rippleConfigs
            |../src/apps/surround-mirror.mts :refer $ surroundMirrorConfigs
            |../src/apps/parallel-mirror.mts :refer $ parallelMirrorConfigs
            |../src/apps/sphere-mirror.mts :refer $ sphereMirrorConfigs
            |../src/apps/hollow-mirror.mts :refer $ hollowMirrorConfigs
            |../src/apps/box-mirror.mts :refer $ boxMirrorConfigs
            |../src/apps/pyramid-mirror.mts :refer $ pyramidMirrorConfigs
            |../src/apps/tetrahedron-mirror.mts :refer $ tetrahedronMirrorConfigs
            |../src/apps/octahedron-mirror.mts :refer $ octahedronMirrorConfigs
            |../src/apps/prism-mirror.mts :refer $ prismMirrorConfigs
            |../src/apps/hex-prism-mirror.mts :refer $ hexPrismMirrorConfigs
            |../src/apps/icosahedron-mirror.mts :refer $ icosahedronMirrorConfigs
            |../src/apps/wedge-mirror.mts :refer $ wedgeMirrorConfigs
            |../src/apps/rhombic-mirror.mts :refer $ rhombicMirrorConfigs
            |../src/apps/rt-mirror.mts :refer $ rtMirrorConfigs
            |../src/apps/dodecahedron-mirror.mts :refer $ dodecahedronMirrorConfigs
            |../src/apps/orbit-spheres-mirror.mts :refer $ orbitSpheresMirrorConfigs
            |../src/apps/dots-clock.mts :refer $ dotsClockConfigs
            |../src/apps/inversion-circles.mts :refer $ inversionCirclesConfigs
            |../src/global.mts :refer $ atomSolubleTree
            app.img-counter :refer $ img-slot!
    |app.schema $ %{} :FileEntry
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def store $ {}
              :tab $ turn-tag
                or
                  .!get
                    new js/URLSearchParams $ .-search js/location
                    , |tab
                  get-env |tab |inversion-circles
              :states $ {}
                :cursor $ []
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                  :states cursor s
                  update-states store cursor s
                (:tab t theme)
                  do
                    let
                        params $ new js/URLSearchParams (.-search js/location)
                        _ $ .!set params |tab (turn-string t)
                      .!replaceState js/history nil || $ str |? (.!toString params)
                    assoc store :tab t
                (:hydrate-storage data) data
                _ $ do (eprintln "|unknown op:" op) store
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
