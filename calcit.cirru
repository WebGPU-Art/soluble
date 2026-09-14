
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ :store reel
                states $ assert-type
                  option:unwrap-or (get store :states) ({})
                  :: 'Map 'Tag 'Dynamic
              div
                {} $ :class-name $ str-spaced css/global css/row
                comp-nav store
                when dev? $ comp-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'Enum (:: 'Map 'Tag 'Dynamic)
        'comp-nav $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-nav (store)
            let
                tab $ assert-type
                  option:unwrap-or (get store :tab) :inversion-circles
                  , 'Tag
              div
                {} $ :class-name style-nav-wrapper
                when (not hide-tabs?)
                  div
                    {} $ :class-name style-nav
                    list->
                      {} $ :style $ {} (:display :flex) (:flex-direction :row) (:gap 4) (:align-items :flex-start)
                      -> tab-groups $ map $ fn (group)
                        let
                            gname $ assert-type (nth group 0) 'String
                            gtabs $ assert-type (nth group 1) (:: 'List 'Enum)
                          [] gname $ div
                            {} $ :class-name style-nav-col
                            div
                              {} $ :class-name style-group-header
                              <> gname
                            list-> ({})
                              -> gtabs $ map $ fn (pair)
                                let
                                    t $ assert-type (&enum:nth pair 0) 'Tag
                                    name $ assert-type (&enum:nth pair 1) 'String
                                  [] t $ div
                                    {}
                                      :class-name $ str-spaced style-tab css/font-fancy!
                                      :on-click $ fn (e d!)
                                        d! $ :: :tab t $ assert-type (&enum:nth pair 2) 'Tag
                                      :style $ if (= tab t)
                                        {} $ :color :white
                                    <> name
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'Map 'Tag 'Dynamic
        'style-group-header $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-group-header
            {} $ |& $ {} (:font-size 10)
              :color $ hsl 0 0 100 0.45
              :padding "|2px 8px 4px"
              :text-transform :uppercase
              :letter-spacing 1
          :examples $ []
          :schema $ :: 'String
        'style-nav $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav
            {} $ |& $ {} (:display :flex) (:flex-direction :row) (:gap 4) (:padding 8) (:align-items :flex-start)
              :background-color $ hsl 0 0 0 0.5
              :border-radius |4px
          :examples $ []
          :schema $ :: 'String
        'style-nav-col $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav-col
            {} $ |& $ {} (:display :flex) (:flex-direction :column) (:min-width 120)
          :examples $ []
          :schema $ :: 'String
        'style-nav-wrapper $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-nav-wrapper
            {}
              |& $ {} (:position :absolute) (:top 0) (:left 0) (:opacity 0) (:transition-duration |300ms) (:transition-property |opacity) (:z-index 10)
              |&:hover $ {} $ :opacity 1
          :examples $ []
          :schema $ :: 'String
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
          :schema $ :: 'String
        'tab-groups $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def tab-groups
            []
              [] |Fractals $ [] (:: :cubic-fire "|Cubic Fire" :dark) (:: :quaternion-fractal "|Quaternion Fractal" :dark) (:: :complex-fractal "|Complex Fractal" :dark) (:: :newton-fractal "|Newton Fractal" :dark) (:: :newton-cosh-fractal "|Newton Cosh Fractal" :dark) (:: :space-fractal "|Space Fractal" :dark) (:: :sphere-fractal "|Sphere Fractal" :dark) (:: :slow-fractal "|Slow Fractal" :dark) (:: :apollonian-twist "|Apollonian Twist" :dark) (:: :apollonian-mobius "|Apollonian Mobius" :dark) (:: :apollonian-helix "|Apollonian Helix" :dark) (:: :apollonian-mobius-helix "|Apollonian Mobius Helix" :dark)
              [] |Effects $ [] (:: :orbits |Orbits :dark) (:: :stars |Stars :dark) (:: :rings |Rings :dark) (:: :circles |Circles :dark) (:: :kaleidoscope |Kaleidoscope :dark) (:: :image |Image :dark) (:: :clocking |Clocking :dark) (:: :ripple |Ripple :dark) (:: :dots-clock "|Dots Clock" :dark) (:: :inversion-circles "|Inversion Circles" :dark)
              [] |Mirrors $ [] (:: :surround-mirror "|Surrond Mirror" :dark) (:: :kaleidoscope-mirror "|Kaleidoscope Mirror" :dark) (:: :parallel-mirror "|Parallel Mirror" :dark) (:: :sphere-mirror "|Sphere Mirror" :dark) (:: :packing-sphere-mirror "|Packing Sphere Mirror" :dark) (:: :orbit-spheres-mirror "|Orbit Spheres Mirror" :dark) (:: :gravity-spheres "|Gravity Spheres" :dark) (:: :pulse-spheres "|Pulse Spheres" :dark) (:: :gravity-cubes "|Gravity Cubes" :dark) (:: :gravity-octahedron "|Gravity Octahedron" :dark) (:: :hollow-mirror "|Hollow Mirror" :dark) (:: :box-mirror "|Box Mirror" :dark) (:: :pyramid-mirror "|Pyramid Mirror" :dark)
              [] |Polyhedra $ [] (:: :tetrahedron-mirror "|Tetrahedron Mirror" :dark) (:: :tetrahedron-parabola-mirror "|Tetrahedron Parabola" :dark) (:: :tetrahedron-arc-mirror "|Tetrahedron Arc" :dark) (:: :cube-parabola-mirror "|Cube Parabola" :dark) (:: :octahedron-mirror "|Octahedron Mirror" :dark) (:: :octahedron-parabola-mirror "|Octahedron Parabola" :dark) (:: :truncated-octahedron-mirror "|Truncated Octahedron" :dark) (:: :cuboctahedron-mirror "|Cuboctahedron Mirror" :dark) (:: :prism-mirror "|Prism Mirror" :dark) (:: :hex-prism-mirror "|Hex Prism Mirror" :dark) (:: :icosahedron-mirror "|Icosahedron Mirror" :dark) (:: :wedge-mirror "|Wedge Mirror" :dark) (:: :rhombohedron-mirror "|Rhombohedron Mirror" :dark) (:: :rhombic-mirror "|Rhombic Mirror" :dark) (:: :rhombic-dodecahedron-diagonals-mirror "|Rhombic Dodecahedron Diagonals" :dark) (:: :rhombic-dodecahedron-parabola-mirror "|Rhombic Dodecahedron Parabola" :dark) (:: :rhombic-dodecahedron-rotating-mirror "|Rhombic Dodecahedron Rotating" :dark) (:: :rt-mirror "|Rhombic Triacontahedron" :dark) (:: :deltoidal-icositetrahedron-mirror "|Deltoidal Icositetrahedron" :dark) (:: :dodecahedron-mirror "|Dodecahedron Mirror" :dark) (:: :crystal-refraction "|Crystal Refraction" :dark)
              [] |Pair $ [] (:: :twin-pulse "|Twin Pulse" :dark) (:: :twin-cubes "|Twin Cubes" :dark) (:: :tetra-octa |Tetra-Octa :dark)
          :examples $ []
          :schema $ :: 'List $ :: 'List 'Dynamic
        'tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def tabs
            [] (:: :cubic-fire "|Cubic Fire" :dark) (:: :quaternion-fractal "|Quaternion Fractal" :dark) (:: :complex-fractal "|Complex Fractal" :dark) (:: :newton-fractal "|Newton Fractal" :dark) (:: :newton-cosh-fractal "|Newton Cosh Fractal" :dark) (:: :space-fractal "|Space Fractal" :dark) (:: :sphere-fractal "|Sphere Fractal" :dark) (:: :slow-fractal "|Slow Fractal" :dark) (:: :apollonian-twist "|Apollonian Twist" :dark) (:: :apollonian-mobius "|Apollonian Mobius" :dark) (:: :apollonian-helix "|Apollonian Helix" :dark) (:: :apollonian-mobius-helix "|Apollonian Mobius Helix" :dark) (:: :orbits |Orbits :dark) (:: :stars |Stars :dark) (:: :rings |Rings :dark) (:: :circles |Circles :dark) (:: :kaleidoscope |Kaleidoscope :dark) (:: :image |Image :dark) (:: :clocking |Clocking :dark) (:: :ripple |Ripple :dark) (:: :surround-mirror "|Surrond Mirror" :dark) (:: :kaleidoscope-mirror "|Kaleidoscope Mirror" :dark) (:: :parallel-mirror "|Parallel Mirror" :dark) (:: :sphere-mirror "|Sphere Mirror" :dark) (:: :packing-sphere-mirror "|Packing Sphere Mirror" :dark) (:: :orbit-spheres-mirror "|Orbit Spheres Mirror" :dark) (:: :hollow-mirror "|Hollow Mirror" :dark) (:: :box-mirror "|Box Mirror" :dark) (:: :pyramid-mirror "|Pyramid Mirror" :dark) (:: :tetrahedron-mirror "|Tetrahedron Mirror" :dark) (:: :tetrahedron-parabola-mirror "|Tetrahedron Parabola" :dark) (:: :tetrahedron-arc-mirror "|Tetrahedron Arc" :dark) (:: :cube-parabola-mirror "|Cube Parabola" :dark) (:: :octahedron-mirror "|Octahedron Mirror" :dark) (:: :octahedron-parabola-mirror "|Octahedron Parabola" :dark) (:: :truncated-octahedron-mirror "|Truncated Octahedron" :dark) (:: :cuboctahedron-mirror "|Cuboctahedron Mirror" :dark) (:: :prism-mirror "|Prism Mirror" :dark) (:: :hex-prism-mirror "|Hex Prism Mirror" :dark) (:: :icosahedron-mirror "|Icosahedron Mirror" :dark) (:: :wedge-mirror "|Wedge Mirror" :dark) (:: :rhombohedron-mirror "|Rhombohedron Mirror" :dark) (:: :rhombic-mirror "|Rhombic Mirror" :dark) (:: :rhombic-dodecahedron-diagonals-mirror "|Rhombic Dodecahedron Diagonals" :dark) (:: :rhombic-dodecahedron-parabola-mirror "|Rhombic Dodecahedron Parabola" :dark) (:: :rhombic-dodecahedron-rotating-mirror "|Rhombic Dodecahedron Rotating" :dark) (:: :rt-mirror "|Rhombic Triacontahedron" :dark) (:: :deltoidal-icositetrahedron-mirror "|Deltoidal Icositetrahedron" :dark) (:: :dodecahedron-mirror "|Dodecahedron Mirror" :dark) (:: :crystal-refraction "|Crystal Refraction" :dark) (:: :dots-clock "|Dots Clock" :dark) (:: :inversion-circles "|Inversion Circles" :dark) (:: :twin-pulse "|Twin Pulse" :dark) (:: :twin-cubes "|Twin Cubes" :dark) (:: :tetra-octa |Tetra-Octa :dark)
          :examples $ []
          :schema $ :: 'List 'Enum
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.css :as css)
            respo.css :refer $ defstyle
            respo.util.format :refer $ hsl
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input list->
            respo.comp.space :refer $ =<
            reel.comp.reel :refer $ comp-reel
            reel.typed :as typed
            app.config :refer $ dev? hide-tabs?
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'default-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def default-tab
            turn-tag $ option:unwrap-or (get-env |tab) |inversion-circles
          :examples $ []
          :schema $ :: 'Tag
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $ option:unwrap-or (get-env |mode) |release
          :examples $ []
          :schema $ :: 'Bool
        'hide-tabs? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def hide-tabs?
            = |true $ option:unwrap-or (get-env |hide-tabs) |false
          :examples $ []
          :schema $ :: 'Bool
        'interval $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def interval 40
          :examples $ []
          :schema $ :: 'Number
        'resource-base-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def resource-base-url (get-env |resource-base-url)
          :examples $ []
          :schema $ :: 'Option 'String
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |workflow
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.img-counter $ %{} 'FileEntry
      :defs $ {}
        '*counter $ %{} 'CodeEntry (:doc "|0-8 slots for pictures")
          :code $ quote $ defatom *counter 0
          :examples $ []
          :schema $ :: 'Ref 'Number
        'img-slot! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn img-slot! ()
            let
                ret @*counter
              if (< ret 8) (swap! *counter inc) (reset! *counter 0)
              , ret
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.img-counter
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*raf $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *raf 0
          :examples $ []
          :schema $ :: 'Ref 'Number
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *reel (typed/new-reel schema/store)
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'Enum (:: 'Map 'Tag 'Dynamic)
        '*timeout $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defatom *timeout 0
          :examples $ []
          :schema $ :: 'Ref 'Number
        'build-shortcut? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn build-shortcut? (event)
            let
                host-event $ unsafe-coerce event KeyboardEventHost
              and
                or
                  unsafe-coerce (js-get host-event :meta-key?) 'Bool
                  unsafe-coerce (js-get host-event :ctrl-key?) 'Bool
                = |b $ unsafe-coerce (js-get host-event :key) 'String
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'current-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn current-tab ()
            let
                store $ :store @*reel
              assert-type
                option:unwrap-or (get store :tab) config/default-tab
                , 'Tag
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Tag)
            :args $ []
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when
              and config/dev? $ not= op :states
              js/console.log |Dispatch: op
            match op
              (:tab t theme) (js/setTimeout handle-tab-op! 0 op)
              _ $ reset! *reel $ next-reel op
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'document-hidden? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn document-hidden? ()
            = |hidden $ unsafe-coerce js/document.visibilityState 'String
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Bool)
            :args $ []
            :features $ #{} :js-ffi
        'get-app $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-app (tab)
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
              :apollonian-twist apollonianTwistConfigs
              :apollonian-mobius apollonianMobiusConfigs
              :apollonian-helix apollonianHelixConfigs
              :apollonian-mobius-helix apollonianMobiusHelixConfigs
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
              :packing-sphere-mirror packingSphereMirrorConfigs
              :orbit-spheres-mirror orbitSpheresMirrorConfigs
              :gravity-spheres gravitySpheresMirrorConfigs
              :pulse-spheres pulseSpheresConfigs
              :gravity-cubes gravityCubesConfigs
              :gravity-octahedron gravityOctahedraConfigs
              :twin-pulse twinPulseConfigs
              :twin-cubes twinCubesConfigs
              :tetra-octa tetraOctaConfigs
              :hollow-mirror hollowMirrorConfigs
              :box-mirror boxMirrorConfigs
              :pyramid-mirror pyramidMirrorConfigs
              :tetrahedron-mirror tetrahedronMirrorConfigs
              :octahedron-mirror octahedronMirrorConfigs
              :truncated-octahedron-mirror truncatedOctahedronMirrorConfigs
              :cuboctahedron-mirror cuboctahedronMirrorConfigs
              :prism-mirror prismMirrorConfigs
              :hex-prism-mirror hexPrismMirrorConfigs
              :icosahedron-mirror icosahedronMirrorConfigs
              :wedge-mirror wedgeMirrorConfigs
              :rhombohedron-mirror rhombohedronMirrorConfigs
              :rhombic-mirror rhombicMirrorConfigs
              :rhombic-dodecahedron-diagonals-mirror rhombicDodecahedronDiagonalsMirrorConfigs
              :tetrahedron-parabola-mirror tetrahedronParabolaMirrorConfigs
              :tetrahedron-arc-mirror tetrahedronArcMirrorConfigs
              :cube-parabola-mirror cubeParabolaMirrorConfigs
              :octahedron-parabola-mirror octahedronParabolaMirrorConfigs
              :rhombic-dodecahedron-parabola-mirror rhombicDodecahedronParabolaMirrorConfigs
              :rhombic-dodecahedron-rotating-mirror rhombicDodecahedronRotatingMirrorConfigs
              :rt-mirror rtMirrorConfigs
              :deltoidal-icositetrahedron-mirror deltoidalIcositetrahedronMirrorConfigs
              :dodecahedron-mirror dodecahedronMirrorConfigs
              :crystal-refraction crystalRefractionConfigs
              :inversion-circles inversionCirclesConfigs
              :dots-clock dotsClockConfigs
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ [] 'Tag
            :features $ #{} :js-ffi
        'get-canvas $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-canvas () (js/document.querySelector |canvas)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ []
            :features $ #{} :js-ffi
        'get-mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-mount-target () (js/document.querySelector |.app)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Dynamic)
            :args $ []
            :features $ #{} :js-ffi
        'get-tab-from-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn get-tab-from-url ()
            let
                host-location $ unsafe-coerce js/location LocationHost
                params $ search-params-create $ unsafe-coerce (js-get host-location :search) 'String
                raw-tab $ search-params-get params |tab
              if (option:some? raw-tab)
                let
                    tab $ turn-tag $ option:unwrap raw-tab
                    found $ find tabs $ fn (item)
                      hint-fn $ {} (:return 'Bool)
                        :args $ [] 'Enum
                      = tab $ assert-type (&enum:nth item 0) 'Tag
                  if (option:some? found) (%some tab) (%none)
                %none
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :features $ #{} :js-ffi
            :return $ :: 'Option 'Tag
        'handle-gamepad! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn handle-gamepad! (events)
            let
                raw-handler $ .?-onButtonEvent $ .?-value atomSolubleTree
              if (js-present? raw-handler)
                do
                  let
                      call! $ unsafe-coerce raw-handler $ :: 'Fn
                        {} (:return 'Dynamic)
                          :args $ [] 'Dynamic
                    call! events
                  , &unit
                , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'handle-tab-op! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn handle-tab-op! (op)
            hint-fn $ {} $ :async true
            js/cancelAnimationFrame @*raf
            js/clearTimeout @*timeout
            js-await $ solublejs/waitForRenderIdle
            reset! *reel $ next-reel op
            loop-paint!
          :examples $ []
          :schema $ :: 'Fn $ {} (:async true) (:return 'Dynamic)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'load-textures! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn load-textures! (device)
            hint-fn $ {} $ :async true
            let
                img-tiye $ solublejs/loadImageAsTexture device $ replace-url |https://cdn.tiye.me/logo/tiye.jpg
                img-candy $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/c7367e21405d602c5ef5a8c55c35d512/candy.jpeg
                img-bubbles $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/20b39957d952bd189e4253369db30335/pasted-2024-04-17T17:00:49.301Z.png
                img-rugs $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/ceec218462f81744323e22dd2d04e94b/pasted-2024-04-17T17:12:29.234Z.png
                img-pigment $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/4a932a1d8eaf46b4d9d8ec07538e8ee1/pigment.jpg
                img-stripes $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/d090a685f03af9d31988a2a92b3b8a19/stripes.jpg
                img-circles $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/80e5932494210d46c600b402a029f973/circles.jpg
                img-sparks $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/3fd6b05f2f9b9a1985224ac39e7b3aee/sparks.jpg
                img-rhombic $ solublejs/loadImageAsTexture device $ replace-url |https://cos-sh.tiye.me/cos-up/309de8ad40b61cb865b32adedf1b2dc4/rhombic-mirror.png
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
          :schema $ :: 'Fn $ {} (:async true) (:return 'Dynamic)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'loop-paint! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn loop-paint! ()
            hint-fn $ {} $ :async true
            js-await $ solublejs/callFramePaint
            if (> config/interval 10)
              reset! *timeout $ schedule-next-paint!
              reset! *raf $ request-next-frame!
          :examples $ []
          :schema $ :: 'Fn $ {} (:async true) (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            hint-fn $ {} $ :async true
            let
                initial-tab $ get-tab-from-url
              when (option:some? initial-tab)
                reset! *reel $ assert-type
                  typed/new-reel $ assoc schema/store :tab $ option:unwrap initial-tab
                  :: 'reel.typed/State 'Enum $ :: 'Map 'Tag 'Dynamic
            println "|Running mode:" $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            let
                ret $ js-await $ solublejs/initializeContext
                device $ .-device ret
              if
                contains?
                  #{} :image :surround-mirror $ ; :sphere-mirror
                  current-tab
                do
                  js-await $ load-textures! device
                  js/window.addEventListener |keydown $ fn (event)
                    hint-fn $ {} $ :async true
                    js/console.log event
                    if (build-shortcut? event)
                      let
                          texture $ js-await $ solublejs/loadImageFromInputEl device
                          k $ img-slot!
                        js-set (.!deref solublejs/atomSharedTextures) k texture
                        js/console.log "|image added to slot" k
                do (load-textures! device) nil
            render-app!
            loop-paint!
            solublejs/resetCanvasHeight $ get-canvas
            js/window.addEventListener |resize $ fn (event)
              solublejs/resetCanvasHeight $ get-canvas
              solublejs/paintSolubleTree
            solublejs/loadGamepadControl handle-gamepad!
            add-watch *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
            js/window.addEventListener |visibilitychange $ fn (event)
              if (document-hidden?) (persist-storage!)
            ; flipped js/setInterval 60000 persist-storage!
            ; let
              (raw (js/localStorage.getItem (:storage-key config/site)))
              when (some? raw)
                dispatch! $ :: :hydrate-storage $ parse-cirru-edn raw
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:async true) (:return 'Dynamic)
            :args $ []
            :features $ #{} :js-ffi
        'next-reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn next-reel (op)
            typed/record-op updater
              assert-type @*reel $ :: 'reel.typed/State 'Enum $ :: 'Map 'Tag 'Dynamic
              assert-type op 'Enum
              generate-id!
              unsafe-coerce js/Date.now 'Number
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
            :return $ :: 'reel.typed/State 'Enum $ :: 'Map 'Tag 'Dynamic
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! () (println "|Saving local state")
            js/localStorage.setItem (:storage-key config/site)
              format-cirru-edn $ :store @*reel
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                js/cancelAnimationFrame @*raf
                render-app!
                loop-paint!
                reset! *reel $ typed/refresh updater
                  assert-type @*reel $ :: 'reel.typed/State 'Enum $ :: 'Map 'Tag 'Dynamic
                  assert-type schema/store $ :: 'Map 'Tag 'Dynamic
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            let
                tab $ current-tab
                app-config $ get-app tab
              solublejs/clearPointsBuffer
              .!initPointsBuffer app-config
              solublejs/renderSolubleTree app-config
            render! (get-mount-target) (comp-container @*reel) dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'replace-url $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn replace-url (url)
            if (option:some? config/resource-base-url)
              str (option:unwrap config/resource-base-url) |/ $ last $ split url |/
              , url
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
        'request-next-frame! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn request-next-frame! ()
            unsafe-coerce
              js/requestAnimationFrame $ fn (t) (loop-paint!)
              , 'Number
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
        'schedule-next-paint! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn schedule-next-paint! ()
            unsafe-coerce
              flipped js/setTimeout config/interval $ fn () $ reset! *raf (request-next-frame!)
              , 'Number
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Number)
            :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container tabs
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools! generate-id!
            reel.typed :as typed
            app.config :as config
            js-ffi.browser :refer $ KeyboardEventHost LocationHost
            js-ffi.shared :refer $ search-params-create search-params-get
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
            |../src/apps/apollonian-twist.mts :refer $ apollonianTwistConfigs
            |../src/apps/apollonian-mobius.mts :refer $ apollonianMobiusConfigs
            |../src/apps/apollonian-helix.mts :refer $ apollonianHelixConfigs
            |../src/apps/apollonian-mobius-helix.mts :refer $ apollonianMobiusHelixConfigs
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
            |../src/apps/packing-sphere-mirror.mts :refer $ packingSphereMirrorConfigs
            |../src/apps/hollow-mirror.mts :refer $ hollowMirrorConfigs
            |../src/apps/box-mirror.mts :refer $ boxMirrorConfigs
            |../src/apps/pyramid-mirror.mts :refer $ pyramidMirrorConfigs
            |../src/apps/tetrahedron-mirror.mts :refer $ tetrahedronMirrorConfigs
            |../src/apps/octahedron-mirror.mts :refer $ octahedronMirrorConfigs
            |../src/apps/truncated-octahedron-mirror.mts :refer $ truncatedOctahedronMirrorConfigs
            |../src/apps/cuboctahedron-mirror.mts :refer $ cuboctahedronMirrorConfigs
            |../src/apps/prism-mirror.mts :refer $ prismMirrorConfigs
            |../src/apps/hex-prism-mirror.mts :refer $ hexPrismMirrorConfigs
            |../src/apps/icosahedron-mirror.mts :refer $ icosahedronMirrorConfigs
            |../src/apps/wedge-mirror.mts :refer $ wedgeMirrorConfigs
            |../src/apps/rhombohedron-mirror.mts :refer $ rhombohedronMirrorConfigs
            |../src/apps/rhombic-mirror.mts :refer $ rhombicMirrorConfigs
            |../src/apps/rhombic-dodecahedron-diagonals-mirror.mts :refer $ rhombicDodecahedronDiagonalsMirrorConfigs
            |../src/apps/tetrahedron-parabola-mirror.mts :refer $ tetrahedronParabolaMirrorConfigs
            |../src/apps/tetrahedron-arc-mirror.mts :refer $ tetrahedronArcMirrorConfigs
            |../src/apps/cube-parabola-mirror.mts :refer $ cubeParabolaMirrorConfigs
            |../src/apps/octahedron-parabola-mirror.mts :refer $ octahedronParabolaMirrorConfigs
            |../src/apps/rhombic-dodecahedron-parabola-mirror.mts :refer $ rhombicDodecahedronParabolaMirrorConfigs
            |../src/apps/rhombic-dodecahedron-rotating-mirror.mts :refer $ rhombicDodecahedronRotatingMirrorConfigs
            |../src/apps/rt-mirror.mts :refer $ rtMirrorConfigs
            |../src/apps/deltoidal-icositetrahedron-mirror.mts :refer $ deltoidalIcositetrahedronMirrorConfigs
            |../src/apps/dodecahedron-mirror.mts :refer $ dodecahedronMirrorConfigs
            |../src/apps/crystal-refraction.mts :refer $ crystalRefractionConfigs
            |../src/apps/orbit-spheres-mirror.mts :refer $ orbitSpheresMirrorConfigs
            |../src/apps/gravity-spheres.mts :refer $ gravitySpheresMirrorConfigs
            |../src/apps/pulse-spheres.mts :refer $ pulseSpheresConfigs
            |../src/apps/gravity-cubes.mts :refer $ gravityCubesConfigs
            |../src/apps/gravity-octahedron.mts :refer $ gravityOctahedraConfigs
            |../src/apps/twin-pulse.mts :refer $ twinPulseConfigs
            |../src/apps/twin-cubes.mts :refer $ twinCubesConfigs
            |../src/apps/tetra-octa.mts :refer $ tetraOctaConfigs
            |../src/apps/dots-clock.mts :refer $ dotsClockConfigs
            |../src/apps/inversion-circles.mts :refer $ inversionCirclesConfigs
            |../src/global.mts :refer $ atomSolubleTree
            app.img-counter :refer $ img-slot!
    'app.schema $ %{} 'FileEntry
      :defs $ {} $ 'store
        %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            {} (:tab default-tab)
              :states $ {} $ :cursor ([])
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
          :require $ app.config :refer $ default-tab
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'replace-tab-url! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn replace-tab-url! (tab)
            .?!replaceState js/history nil || $ str |?tab= $ turn-string tab
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Tag
            :features $ #{} :js-ffi
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor s) (update-states store cursor s)
              (:tab t theme)
                do (replace-tab-url! t) (assoc store :tab t)
              (:hydrate-storage data) data
              _ $ do (eprintln "|unknown op:" op) store
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'Enum 'String 'Number
            :return $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-states
