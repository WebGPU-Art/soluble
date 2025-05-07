
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:output |src) (:port 6001) (:reload-fn |app.main/reload!) (:storage-key |calcit.cirru) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |comp-container $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |defcomp)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |comp-container)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1507461830530) (:by |root) (:text |reel)
              |v $ %{} :Expr (:at 1507461832154) (:by |root)
                :data $ {}
                  |D $ %{} :Leaf (:at 1507461833421) (:by |root) (:text |let)
                  |L $ %{} :Expr (:at 1507461834351) (:by |root)
                    :data $ {}
                      |T $ %{} :Expr (:at 1507461834650) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1507461835738) (:by |root) (:text |store)
                          |j $ %{} :Expr (:at 1507461836110) (:by |root)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1507461837276) (:by |root) (:text |:store)
                              |j $ %{} :Leaf (:at 1507461838285) (:by |root) (:text |reel)
                      |j $ %{} :Expr (:at 1509727104820) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1509727105928) (:by |root) (:text |states)
                          |j $ %{} :Expr (:at 1509727106316) (:by |root)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1509727107223) (:by |root) (:text |:states)
                              |j $ %{} :Leaf (:at 1626777497473) (:by |rJG4IHzWf) (:text |store)
                      |n $ %{} :Expr (:at 1584780921790) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1584780923771) (:by |rJG4IHzWf) (:text |cursor)
                          |j $ %{} :Expr (:at 1584780991636) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1627849325504) (:by |rJG4IHzWf) (:text |or)
                              |T $ %{} :Expr (:at 1584780923944) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1584780925829) (:by |rJG4IHzWf) (:text |:cursor)
                                  |j $ %{} :Leaf (:at 1584780926681) (:by |rJG4IHzWf) (:text |states)
                              |b $ %{} :Expr (:at 1679237728653) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1679237728821) (:by |rJG4IHzWf) (:text |[])
                      |r $ %{} :Expr (:at 1584780887905) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1584780889620) (:by |rJG4IHzWf) (:text |state)
                          |j $ %{} :Expr (:at 1584780889933) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1627849327831) (:by |rJG4IHzWf) (:text |or)
                              |j $ %{} :Expr (:at 1584780894090) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1584780894689) (:by |rJG4IHzWf) (:text |:data)
                                  |j $ %{} :Leaf (:at 1584780900314) (:by |rJG4IHzWf) (:text |states)
                              |r $ %{} :Expr (:at 1584780901014) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1584780901408) (:by |rJG4IHzWf) (:text |{})
                                  |j $ %{} :Expr (:at 1584780901741) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1584780906050) (:by |rJG4IHzWf) (:text |:content)
                                      |j $ %{} :Leaf (:at 1584780907617) (:by |rJG4IHzWf) (:text "|\"")
                  |T $ %{} :Expr (:at 1499755354983) (:by nil)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |div)
                      |j $ %{} :Expr (:at 1499755354983) (:by nil)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |{})
                          |j $ %{} :Expr (:at 1499755354983) (:by nil)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1695659805533) (:by |rJG4IHzWf) (:text |:class-name)
                              |j $ %{} :Expr (:at 1499755354983) (:by nil)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1695659808341) (:by |rJG4IHzWf) (:text |str-spaced)
                                  |j $ %{} :Leaf (:at 1695659810151) (:by |rJG4IHzWf) (:text |css/global)
                                  |r $ %{} :Leaf (:at 1695659811823) (:by |rJG4IHzWf) (:text |css/row)
                      |n $ %{} :Expr (:at 1699463252470) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463253695) (:by |rJG4IHzWf) (:text |comp-nav)
                          |b $ %{} :Leaf (:at 1699463257354) (:by |rJG4IHzWf) (:text |store)
                      |x $ %{} :Expr (:at 1521954055333) (:by |root)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1521954057510) (:by |root) (:text |when)
                          |L $ %{} :Leaf (:at 1521954059290) (:by |root) (:text |dev?)
                          |T $ %{} :Expr (:at 1507461809635) (:by |root)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1507461815046) (:by |root) (:text |comp-reel)
                              |b $ %{} :Expr (:at 1584780610581) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1584780611347) (:by |rJG4IHzWf) (:text |>>)
                                  |T $ %{} :Leaf (:at 1509727101297) (:by |root) (:text |states)
                                  |j $ %{} :Leaf (:at 1584780613268) (:by |rJG4IHzWf) (:text |:reel)
                              |j $ %{} :Leaf (:at 1507461840459) (:by |root) (:text |reel)
                              |r $ %{} :Expr (:at 1507461840980) (:by |root)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1507461841342) (:by |root) (:text |{})
        |comp-nav $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699463214336) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699463227915) (:by |rJG4IHzWf) (:text |defcomp)
              |b $ %{} :Leaf (:at 1699463214336) (:by |rJG4IHzWf) (:text |comp-nav)
              |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |store)
              |l $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |let)
                  |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |tab)
                          |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:tab)
                              |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |store)
                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |show-tabs?)
                          |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |and)
                              |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |not)
                                  |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |hide-tabs?)
                              |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:show-tabs?)
                                  |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |store)
                  |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |div)
                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |{})
                          |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:class-name)
                              |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |style-nav)
                      |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |if)
                          |b $ %{} :Expr (:at 1699463467266) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1699463468592) (:by |rJG4IHzWf) (:text |not)
                              |T $ %{} :Leaf (:at 1699463466626) (:by |rJG4IHzWf) (:text |hide-tabs?)
                          |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |list->)
                              |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |{})
                              |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |->)
                                  |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |tabs)
                                  |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |map)
                                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                        :data $ {}
                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |fn)
                                          |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |pair)
                                          |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |let)
                                              |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                    :data $ {}
                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |t)
                                                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                        :data $ {}
                                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |nth)
                                                          |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |pair)
                                                          |h $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |0)
                                                  |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                    :data $ {}
                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |name)
                                                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                        :data $ {}
                                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |nth)
                                                          |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |pair)
                                                          |h $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |1)
                                              |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |[])
                                                  |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |t)
                                                  |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                    :data $ {}
                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |div)
                                                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                        :data $ {}
                                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |{})
                                                          |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                            :data $ {}
                                                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:class-name)
                                                              |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                :data $ {}
                                                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |str-spaced)
                                                                  |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |style-tab)
                                                                  |h $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |css/font-fancy!)
                                                          |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                            :data $ {}
                                                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:on-click)
                                                              |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                :data $ {}
                                                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |fn)
                                                                  |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                    :data $ {}
                                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |e)
                                                                      |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |d!)
                                                                  |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                    :data $ {}
                                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |d!)
                                                                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                        :data $ {}
                                                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |::)
                                                                          |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:tab)
                                                                          |h $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |t)
                                                                          |l $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                            :data $ {}
                                                                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |nth)
                                                                              |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |pair)
                                                                              |h $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |2)
                                                          |l $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                            :data $ {}
                                                              |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:style)
                                                              |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                :data $ {}
                                                                  |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |if)
                                                                  |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                    :data $ {}
                                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |=)
                                                                      |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |tab)
                                                                      |h $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |t)
                                                                  |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                    :data $ {}
                                                                      |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |{})
                                                                      |b $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                                        :data $ {}
                                                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:color)
                                                                          |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |:white)
                                                      |h $ %{} :Expr (:at 1699463221360) (:by |rJG4IHzWf)
                                                        :data $ {}
                                                          |T $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |<>)
                                                          |b $ %{} :Leaf (:at 1699463221360) (:by |rJG4IHzWf) (:text |name)
        |style-nav $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699463351193) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699463355191) (:by |rJG4IHzWf) (:text |defstyle)
              |b $ %{} :Leaf (:at 1699463351193) (:by |rJG4IHzWf) (:text |style-nav)
              |h $ %{} :Expr (:at 1699463353227) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text |{})
                  |b $ %{} :Expr (:at 1699463353227) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text "|\"&")
                      |b $ %{} :Expr (:at 1699463353227) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text |{})
                          |b $ %{} :Expr (:at 1699463353227) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text |:position)
                              |b $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text |:absolute)
                          |h $ %{} :Expr (:at 1699463353227) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text |:top)
                              |b $ %{} :Leaf (:at 1699463353227) (:by |rJG4IHzWf) (:text |12)
        |style-tab $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699463319508) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699463323684) (:by |rJG4IHzWf) (:text |defstyle)
              |b $ %{} :Leaf (:at 1699463319508) (:by |rJG4IHzWf) (:text |style-tab)
              |h $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |{})
                  |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text "|\"&")
                      |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |{})
                          |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:line-height)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text "|\"1.4")
                          |h $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:margin-top)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |2)
                          |l $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:padding)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text "|\"0 8px")
                          |o $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:width)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:fit-content)
                          |q $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:color)
                              |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |hsl)
                                  |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |h $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |l $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |100)
                                  |o $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0.5)
                          |s $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:cursor)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:pointer)
                          |t $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:transition-duration)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text "|\"200ms")
                          |u $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:border-radius)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text "|\"4px")
                          |v $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:background-color)
                              |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |hsl)
                                  |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |h $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |l $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |o $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0.2)
                  |h $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text "|\"&:hover")
                      |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |{})
                          |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:background-color)
                              |b $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |hsl)
                                  |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |h $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |l $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0)
                                  |o $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |0.5)
                          |h $ %{} :Expr (:at 1699463320650) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:color)
                              |b $ %{} :Leaf (:at 1699463320650) (:by |rJG4IHzWf) (:text |:white)
        |tabs $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699463292254) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699463292254) (:by |rJG4IHzWf) (:text |def)
              |b $ %{} :Leaf (:at 1699463292254) (:by |rJG4IHzWf) (:text |tabs)
              |h $ %{} :Expr (:at 1699463292254) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463294817) (:by |rJG4IHzWf) (:text |[])
                  |b $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1699463490067) (:by |rJG4IHzWf) (:text |:cubic-fire)
                      |h $ %{} :Leaf (:at 1699463494302) (:by |rJG4IHzWf) (:text "|\"Cubic Fire")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |h $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1699463507003) (:by |rJG4IHzWf) (:text |:quaternion-fractal)
                      |h $ %{} :Leaf (:at 1699463513642) (:by |rJG4IHzWf) (:text "|\"Quaternion Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |l $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1699463521054) (:by |rJG4IHzWf) (:text |:complex-fractal)
                      |h $ %{} :Leaf (:at 1699463523436) (:by |rJG4IHzWf) (:text "|\"Complex Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |m $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1722186740245) (:by |rJG4IHzWf) (:text |:newton-fractal)
                      |h $ %{} :Leaf (:at 1722186742904) (:by |rJG4IHzWf) (:text "|\"Newton Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |n $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1722621190307) (:by |rJG4IHzWf) (:text |:newton-cosh-fractal)
                      |h $ %{} :Leaf (:at 1722621193398) (:by |rJG4IHzWf) (:text "|\"Newton Cosh Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |o $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1699463524789) (:by |rJG4IHzWf) (:text |:space-fractal)
                      |h $ %{} :Leaf (:at 1699463526136) (:by |rJG4IHzWf) (:text "|\"Space Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |q $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1699463539861) (:by |rJG4IHzWf) (:text |:sphere-fractal)
                      |h $ %{} :Leaf (:at 1699463543803) (:by |rJG4IHzWf) (:text "|\"Sphere Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |s $ %{} :Expr (:at 1699463295143) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463295535) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1699463553440) (:by |rJG4IHzWf) (:text |:slow-fractal)
                      |h $ %{} :Leaf (:at 1699463551652) (:by |rJG4IHzWf) (:text "|\"Slow Fractal")
                      |l $ %{} :Leaf (:at 1699463306212) (:by |rJG4IHzWf) (:text |:dark)
                  |t $ %{} :Expr (:at 1709313639236) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709313639781) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1709313645479) (:by |rJG4IHzWf) (:text |:orbits)
                      |h $ %{} :Leaf (:at 1709313648187) (:by |rJG4IHzWf) (:text "|\"Orbits")
                      |l $ %{} :Leaf (:at 1709313652440) (:by |rJG4IHzWf) (:text |:dark)
                  |u $ %{} :Expr (:at 1709313639236) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709313639781) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1709658620965) (:by |rJG4IHzWf) (:text |:stars)
                      |h $ %{} :Leaf (:at 1709658622724) (:by |rJG4IHzWf) (:text "|\"Stars")
                      |l $ %{} :Leaf (:at 1709313652440) (:by |rJG4IHzWf) (:text |:dark)
                  |v $ %{} :Expr (:at 1709313639236) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709313639781) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1710871525460) (:by |rJG4IHzWf) (:text |:rings)
                      |h $ %{} :Leaf (:at 1710871527711) (:by |rJG4IHzWf) (:text "|\"Rings")
                      |l $ %{} :Leaf (:at 1709313652440) (:by |rJG4IHzWf) (:text |:dark)
                  |w $ %{} :Expr (:at 1709313639236) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709313639781) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1711166637235) (:by |rJG4IHzWf) (:text |:circles)
                      |h $ %{} :Leaf (:at 1711166639067) (:by |rJG4IHzWf) (:text "|\"Circles")
                      |l $ %{} :Leaf (:at 1709313652440) (:by |rJG4IHzWf) (:text |:dark)
                  |x $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1712938637452) (:by |rJG4IHzWf) (:text |:kaleidoscope)
                      |h $ %{} :Leaf (:at 1712938640622) (:by |rJG4IHzWf) (:text "|\"Kaleidoscope")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |y $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1713296809104) (:by |rJG4IHzWf) (:text |:image)
                      |h $ %{} :Leaf (:at 1713296812474) (:by |rJG4IHzWf) (:text "|\"Image")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |z $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1714755215218) (:by |rJG4IHzWf) (:text |:clocking)
                      |h $ %{} :Leaf (:at 1714755229863) (:by |rJG4IHzWf) (:text "|\"Clocking")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zD $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1714883742296) (:by |rJG4IHzWf) (:text |:ripple)
                      |h $ %{} :Leaf (:at 1714883746119) (:by |rJG4IHzWf) (:text "|\"Ripple")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zP $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1716718542242) (:by |rJG4IHzWf) (:text |:surround-mirror)
                      |h $ %{} :Leaf (:at 1716718439892) (:by |rJG4IHzWf) (:text "|\"Surrond Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zT $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1722106566687) (:by |rJG4IHzWf) (:text |:kaleidoscope-mirror)
                      |h $ %{} :Leaf (:at 1722106573757) (:by |rJG4IHzWf) (:text "|\"Kaleidoscope Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zY $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1717259971868) (:by |rJG4IHzWf) (:text |:parallel-mirror)
                      |h $ %{} :Leaf (:at 1717259976676) (:by |rJG4IHzWf) (:text "|\"Parallel Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |ze $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1719132374213) (:by |rJG4IHzWf) (:text |:sphere-mirror)
                      |h $ %{} :Leaf (:at 1719132379623) (:by |rJG4IHzWf) (:text "|\"Sphere Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zj $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1721236360129) (:by |rJG4IHzWf) (:text |:hollow-mirror)
                      |h $ %{} :Leaf (:at 1721236361924) (:by |rJG4IHzWf) (:text "|\"Hollow Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zn $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1724345106003) (:by |rJG4IHzWf) (:text |:box-mirror)
                      |h $ %{} :Leaf (:at 1724345107962) (:by |rJG4IHzWf) (:text "|\"Box Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
                  |zq $ %{} :Expr (:at 1712938631055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938631792) (:by |rJG4IHzWf) (:text |::)
                      |b $ %{} :Leaf (:at 1731209309368) (:by |rJG4IHzWf) (:text |:rhombic-mirror)
                      |h $ %{} :Leaf (:at 1731209314741) (:by |rJG4IHzWf) (:text "|\"Rhombic Mirror")
                      |l $ %{} :Leaf (:at 1712938641596) (:by |rJG4IHzWf) (:text |:dark)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1499755354983) (:by nil)
          :data $ {}
            |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |ns)
            |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |app.comp.container)
            |v $ %{} :Expr (:at 1499755354983) (:by nil)
              :data $ {}
                |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:require)
                |r $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1695659797743) (:by |rJG4IHzWf) (:text |respo-ui.css)
                    |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:as)
                    |v $ %{} :Leaf (:at 1695659799627) (:by |rJG4IHzWf) (:text |css)
                |t $ %{} :Expr (:at 1695659844346) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1695659847085) (:by |rJG4IHzWf) (:text |respo.css)
                    |b $ %{} :Leaf (:at 1695659847949) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1695659848197) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1695659850247) (:by |rJG4IHzWf) (:text |defstyle)
                |u $ %{} :Expr (:at 1699463334631) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1699463337314) (:by |rJG4IHzWf) (:text |respo.util.format)
                    |b $ %{} :Leaf (:at 1699463338089) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699463338308) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699463338698) (:by |rJG4IHzWf) (:text |hsl)
                |v $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1540958704705) (:by |root) (:text |respo.core)
                    |r $ %{} :Leaf (:at 1508946162679) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1499755354983) (:by nil)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |defcomp)
                        |l $ %{} :Leaf (:at 1573355389740) (:by |rJG4IHzWf) (:text |defeffect)
                        |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |<>)
                        |t $ %{} :Leaf (:at 1584780606618) (:by |rJG4IHzWf) (:text |>>)
                        |v $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |div)
                        |x $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |button)
                        |xT $ %{} :Leaf (:at 1512359490531) (:by |rJG4IHzWf) (:text |textarea)
                        |y $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |span)
                        |yT $ %{} :Leaf (:at 1552321107012) (:by |rJG4IHzWf) (:text |input)
                        |z $ %{} :Leaf (:at 1699463274269) (:by |rJG4IHzWf) (:text |list->)
                |x $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |respo.comp.space)
                    |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1499755354983) (:by nil)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |=<)
                |y $ %{} :Expr (:at 1507461845717) (:by |root)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1507461855480) (:by |root) (:text |reel.comp.reel)
                    |r $ %{} :Leaf (:at 1507461856264) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1507461856484) (:by |root)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1507461858342) (:by |root) (:text |comp-reel)
                |yj $ %{} :Expr (:at 1521954061310) (:by |root)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1527788377809) (:by |root) (:text |app.config)
                    |r $ %{} :Leaf (:at 1521954064826) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1521954065004) (:by |root)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1521954067604) (:by |root) (:text |dev?)
                        |n $ %{} :Leaf (:at 1699463461189) (:by |rJG4IHzWf) (:text |hide-tabs?)
    |app.config $ %{} :FileEntry
      :defs $ {}
        |dev? $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1544873875614) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1544873875614) (:by |rJG4IHzWf) (:text |def)
              |j $ %{} :Leaf (:at 1544873875614) (:by |rJG4IHzWf) (:text |dev?)
              |r $ %{} :Expr (:at 1624469709435) (:by |rJG4IHzWf)
                :data $ {}
                  |5 $ %{} :Leaf (:at 1624469715390) (:by |rJG4IHzWf) (:text |=)
                  |D $ %{} :Leaf (:at 1624469714304) (:by |rJG4IHzWf) (:text "|\"dev")
                  |T $ %{} :Expr (:at 1624469701389) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1624469706777) (:by |rJG4IHzWf) (:text |get-env)
                      |T $ %{} :Leaf (:at 1624469708397) (:by |rJG4IHzWf) (:text "|\"mode")
                      |b $ %{} :Leaf (:at 1658121345573) (:by |rJG4IHzWf) (:text "|\"release")
        |hide-tabs? $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699463394108) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699463394108) (:by |rJG4IHzWf) (:text |def)
              |b $ %{} :Leaf (:at 1699463394108) (:by |rJG4IHzWf) (:text |hide-tabs?)
              |h $ %{} :Expr (:at 1699463401265) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463401265) (:by |rJG4IHzWf) (:text |=)
                  |b $ %{} :Leaf (:at 1699463401265) (:by |rJG4IHzWf) (:text "|\"true")
                  |h $ %{} :Expr (:at 1699463401265) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463401265) (:by |rJG4IHzWf) (:text |get-env)
                      |b $ %{} :Leaf (:at 1699463401265) (:by |rJG4IHzWf) (:text "|\"hide-tabs")
                      |h $ %{} :Leaf (:at 1699463401265) (:by |rJG4IHzWf) (:text "|\"false")
        |interval $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699464828651) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699464828651) (:by |rJG4IHzWf) (:text |def)
              |b $ %{} :Leaf (:at 1699464828651) (:by |rJG4IHzWf) (:text |interval)
              |h $ %{} :Expr (:at 1712939415634) (:by |rJG4IHzWf)
                :data $ {}
                  |D $ %{} :Leaf (:at 1712939417546) (:by |rJG4IHzWf) (:text |w-js-log)
                  |T $ %{} :Expr (:at 1699464847007) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1699464875144) (:by |rJG4IHzWf) (:text |parse-float)
                      |T $ %{} :Expr (:at 1699464828651) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699464836463) (:by |rJG4IHzWf) (:text |get-env)
                          |b $ %{} :Leaf (:at 1699464838265) (:by |rJG4IHzWf) (:text "|\"interval")
                          |h $ %{} :Leaf (:at 1699465043647) (:by |rJG4IHzWf) (:text "|\"40")
        |resource-base-url $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1744560561594) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1744560562755) (:by |rJG4IHzWf) (:text |def)
              |b $ %{} :Leaf (:at 1744560561594) (:by |rJG4IHzWf) (:text |resource-base-url)
              |h $ %{} :Expr (:at 1744560561594) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1744560564783) (:by |rJG4IHzWf) (:text |get-env)
                  |b $ %{} :Leaf (:at 1744560565737) (:by |rJG4IHzWf) (:text "|\"resource-base-url")
        |site $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1545933382603) (:by |root)
            :data $ {}
              |T $ %{} :Leaf (:at 1518157345496) (:by |root) (:text |def)
              |j $ %{} :Leaf (:at 1518157327696) (:by |root) (:text |site)
              |r $ %{} :Expr (:at 1518157327696) (:by |root)
                :data $ {}
                  |T $ %{} :Leaf (:at 1518157346643) (:by |root) (:text |{})
                  |yf $ %{} :Expr (:at 1544956719115) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1544956719115) (:by |rJG4IHzWf) (:text |:storage-key)
                      |j $ %{} :Leaf (:at 1544956719115) (:by |rJG4IHzWf) (:text "|\"workflow")
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1527788237503) (:by |root)
          :data $ {}
            |T $ %{} :Leaf (:at 1527788237503) (:by |root) (:text |ns)
            |j $ %{} :Leaf (:at 1527788237503) (:by |root) (:text |app.config)
    |app.img-counter $ %{} :FileEntry
      :defs $ {}
        |*counter $ %{} :CodeEntry (:doc "|0-8 slots for pictures")
          :code $ %{} :Expr (:at 1744515962979) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1744515967506) (:by |rJG4IHzWf) (:text |defatom)
              |b $ %{} :Leaf (:at 1744515962979) (:by |rJG4IHzWf) (:text |*counter)
              |h $ %{} :Leaf (:at 1744515969243) (:by |rJG4IHzWf) (:text |0)
        |img-slot! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1744516000695) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1744516000695) (:by |rJG4IHzWf) (:text |defn)
              |b $ %{} :Leaf (:at 1744516000695) (:by |rJG4IHzWf) (:text |img-slot!)
              |h $ %{} :Expr (:at 1744516000695) (:by |rJG4IHzWf)
                :data $ {}
              |l $ %{} :Expr (:at 1744516003246) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1744516004964) (:by |rJG4IHzWf) (:text |let)
                  |b $ %{} :Expr (:at 1744516005699) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Expr (:at 1744516008193) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744516007792) (:by |rJG4IHzWf) (:text |ret)
                          |b $ %{} :Leaf (:at 1744516013737) (:by |rJG4IHzWf) (:text |@*counter)
                  |e $ %{} :Expr (:at 1744516031515) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1744516032037) (:by |rJG4IHzWf) (:text |if)
                      |L $ %{} :Expr (:at 1744516033222) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744516040120) (:by |rJG4IHzWf) (:text |<)
                          |b $ %{} :Leaf (:at 1744516042175) (:by |rJG4IHzWf) (:text |ret)
                          |h $ %{} :Leaf (:at 1744516043226) (:by |rJG4IHzWf) (:text |8)
                      |T $ %{} :Expr (:at 1744516022977) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744516025143) (:by |rJG4IHzWf) (:text |swap!)
                          |b $ %{} :Leaf (:at 1744516027824) (:by |rJG4IHzWf) (:text |*counter)
                          |h $ %{} :Leaf (:at 1744516028595) (:by |rJG4IHzWf) (:text |inc)
                      |b $ %{} :Expr (:at 1744516046697) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744516047440) (:by |rJG4IHzWf) (:text |reset!)
                          |b $ %{} :Leaf (:at 1744516049127) (:by |rJG4IHzWf) (:text |*counter)
                          |h $ %{} :Leaf (:at 1744516049742) (:by |rJG4IHzWf) (:text |0)
                  |h $ %{} :Leaf (:at 1744516020843) (:by |rJG4IHzWf) (:text |ret)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1744515959109) (:by |rJG4IHzWf)
          :data $ {}
            |T $ %{} :Leaf (:at 1744515959109) (:by |rJG4IHzWf) (:text |ns)
            |b $ %{} :Leaf (:at 1744515959109) (:by |rJG4IHzWf) (:text |app.img-counter)
    |app.main $ %{} :FileEntry
      :defs $ {}
        |*compute-shader $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699464055289) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699464056788) (:by |rJG4IHzWf) (:text |defatom)
              |b $ %{} :Leaf (:at 1699464055289) (:by |rJG4IHzWf) (:text |*compute-shader)
              |h $ %{} :Leaf (:at 1699464059556) (:by |rJG4IHzWf) (:text |nil)
        |*raf $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699464218640) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699464219756) (:by |rJG4IHzWf) (:text |defatom)
              |b $ %{} :Leaf (:at 1699464218640) (:by |rJG4IHzWf) (:text |*raf)
              |h $ %{} :Leaf (:at 1699464221695) (:by |rJG4IHzWf) (:text |0)
        |*reel $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1610792986987) (:by |rJG4IHzWf) (:text |defatom)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |*reel)
              |r $ %{} :Expr (:at 1507399777531) (:by |root)
                :data $ {}
                  |D $ %{} :Leaf (:at 1507399778895) (:by |root) (:text |->)
                  |T $ %{} :Leaf (:at 1507399776350) (:by |root) (:text |reel-schema/reel)
                  |j $ %{} :Expr (:at 1507399779656) (:by |root)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1507399781682) (:by |root) (:text |assoc)
                      |j $ %{} :Leaf (:at 1507401405076) (:by |root) (:text |:base)
                      |r $ %{} :Leaf (:at 1507399787471) (:by |root) (:text |schema/store)
                  |r $ %{} :Expr (:at 1507399779656) (:by |root)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1507399781682) (:by |root) (:text |assoc)
                      |j $ %{} :Leaf (:at 1507399793097) (:by |root) (:text |:store)
                      |r $ %{} :Leaf (:at 1507399787471) (:by |root) (:text |schema/store)
        |*timeout $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699464175515) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699464177063) (:by |rJG4IHzWf) (:text |defatom)
              |b $ %{} :Leaf (:at 1699464175515) (:by |rJG4IHzWf) (:text |*timeout)
              |h $ %{} :Leaf (:at 1699464179099) (:by |rJG4IHzWf) (:text |0)
        |canvas $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699464260109) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699464260109) (:by |rJG4IHzWf) (:text |def)
              |b $ %{} :Leaf (:at 1699464260109) (:by |rJG4IHzWf) (:text |canvas)
              |h $ %{} :Expr (:at 1699464260109) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699464267334) (:by |rJG4IHzWf) (:text |js/document.querySelector)
                  |b $ %{} :Leaf (:at 1699464268561) (:by |rJG4IHzWf) (:text "|\"canvas")
        |dispatch! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |defn)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |dispatch!)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |op)
              |t $ %{} :Expr (:at 1547437686766) (:by |root)
                :data $ {}
                  |D $ %{} :Leaf (:at 1547437687530) (:by |root) (:text |when)
                  |L $ %{} :Expr (:at 1584874661674) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1584874662518) (:by |rJG4IHzWf) (:text |and)
                      |T $ %{} :Leaf (:at 1547437691006) (:by |root) (:text |config/dev?)
                      |j $ %{} :Expr (:at 1584874663522) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1584874664551) (:by |rJG4IHzWf) (:text |not=)
                          |j $ %{} :Leaf (:at 1584874665829) (:by |rJG4IHzWf) (:text |op)
                          |r $ %{} :Leaf (:at 1584874671745) (:by |rJG4IHzWf) (:text |:states)
                  |T $ %{} :Expr (:at 1518156274050) (:by |root)
                    :data $ {}
                      |j $ %{} :Leaf (:at 1692546015701) (:by |rJG4IHzWf) (:text |js/console.log)
                      |r $ %{} :Leaf (:at 1547437698992) (:by |root) (:text "|\"Dispatch:")
                      |v $ %{} :Leaf (:at 1518156280471) (:by |root) (:text |op)
              |u $ %{} :Expr (:at 1709660917868) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1713005698074) (:by |rJG4IHzWf) (:text |solublejs/clearPointsBuffer)
              |v $ %{} :Expr (:at 1584780634192) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |reset!)
                  |j $ %{} :Leaf (:at 1507399899641) (:by |root) (:text |*reel)
                  |r $ %{} :Expr (:at 1507399884621) (:by |root)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1507399887573) (:by |root) (:text |reel-updater)
                      |j $ %{} :Leaf (:at 1507399888500) (:by |root) (:text |updater)
                      |r $ %{} :Leaf (:at 1507399891576) (:by |root) (:text |@*reel)
                      |v $ %{} :Leaf (:at 1507399892687) (:by |root) (:text |op)
        |get-app $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699463992142) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699463992142) (:by |rJG4IHzWf) (:text |defn)
              |b $ %{} :Leaf (:at 1699463992142) (:by |rJG4IHzWf) (:text |get-app)
              |h $ %{} :Expr (:at 1699463992142) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463992142) (:by |rJG4IHzWf) (:text |tab)
              |l $ %{} :Expr (:at 1699464506049) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699464509140) (:by |rJG4IHzWf) (:text |case-default)
                  |b $ %{} :Leaf (:at 1699464510217) (:by |rJG4IHzWf) (:text |tab)
                  |e $ %{} :Expr (:at 1710871325219) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1710871325869) (:by |rJG4IHzWf) (:text |do)
                      |T $ %{} :Expr (:at 1709660684600) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1709660690182) (:by |rJG4IHzWf) (:text |js/console.warn)
                          |L $ %{} :Leaf (:at 1709660693256) (:by |rJG4IHzWf) (:text "|\"Unknown tab")
                          |P $ %{} :Leaf (:at 1709660693845) (:by |rJG4IHzWf) (:text |tab)
                      |b $ %{} :Leaf (:at 1710871329020) (:by |rJG4IHzWf) (:text |cubicFireConfigs)
                  |h $ %{} :Expr (:at 1699464510573) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464527449) (:by |rJG4IHzWf) (:text |:cubic-fire)
                      |b $ %{} :Leaf (:at 1699464568417) (:by |rJG4IHzWf) (:text |cubicFireConfigs)
                  |l $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464614555) (:by |rJG4IHzWf) (:text |:quaternion-fractal)
                      |b $ %{} :Leaf (:at 1699464625784) (:by |rJG4IHzWf) (:text |quaternionFractalConfigs)
                  |o $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464686343) (:by |rJG4IHzWf) (:text |:complex-fractal)
                      |b $ %{} :Leaf (:at 1699464689787) (:by |rJG4IHzWf) (:text |complexFractalConfigs)
                  |p $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1722186750996) (:by |rJG4IHzWf) (:text |:newton-fractal)
                      |b $ %{} :Leaf (:at 1722186754722) (:by |rJG4IHzWf) (:text |newtonFractalConfigs)
                  |pT $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1722621207951) (:by |rJG4IHzWf) (:text |:newton-cosh-fractal)
                      |b $ %{} :Leaf (:at 1722621211745) (:by |rJG4IHzWf) (:text |newtonCoshFractalConfigs)
                  |q $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464695179) (:by |rJG4IHzWf) (:text |:space-fractal)
                      |b $ %{} :Leaf (:at 1699464696753) (:by |rJG4IHzWf) (:text |spaceFractalConfigs)
                  |r $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464706710) (:by |rJG4IHzWf) (:text |:sphere-fractal)
                      |b $ %{} :Leaf (:at 1699464709260) (:by |rJG4IHzWf) (:text |sphereFractalConfigs)
                  |s $ %{} :Expr (:at 1699464610730) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464700007) (:by |rJG4IHzWf) (:text |:slow-fractal)
                      |b $ %{} :Leaf (:at 1699464701893) (:by |rJG4IHzWf) (:text |slowFractalConfigs)
                  |t $ %{} :Expr (:at 1709313727146) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709314044941) (:by |rJG4IHzWf) (:text |:orbits)
                      |b $ %{} :Leaf (:at 1709313856302) (:by |rJG4IHzWf) (:text |orbitsConfigs)
                  |u $ %{} :Expr (:at 1709313727146) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709658638811) (:by |rJG4IHzWf) (:text |:stars)
                      |b $ %{} :Leaf (:at 1709658667646) (:by |rJG4IHzWf) (:text |stars/configs)
                  |v $ %{} :Expr (:at 1710871533736) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1710871535494) (:by |rJG4IHzWf) (:text |:rings)
                      |b $ %{} :Leaf (:at 1710871538129) (:by |rJG4IHzWf) (:text |rings/configs)
                  |w $ %{} :Expr (:at 1710871533736) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1711166650202) (:by |rJG4IHzWf) (:text |:circles)
                      |b $ %{} :Leaf (:at 1711166652293) (:by |rJG4IHzWf) (:text |circles/configs)
                  |x $ %{} :Expr (:at 1712938927592) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1712938931280) (:by |rJG4IHzWf) (:text |:kaleidoscope)
                      |b $ %{} :Leaf (:at 1712938938104) (:by |rJG4IHzWf) (:text |kaleidoscopeConfigs)
                  |xD $ %{} :Expr (:at 1712938927592) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1722106582528) (:by |rJG4IHzWf) (:text |:kaleidoscope-mirror)
                      |b $ %{} :Leaf (:at 1722106707210) (:by |rJG4IHzWf) (:text |kaleidoscopeMirrorConfigs)
                  |xT $ %{} :Expr (:at 1712938927592) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1714755661461) (:by |rJG4IHzWf) (:text |:clocking)
                      |b $ %{} :Leaf (:at 1714755662694) (:by |rJG4IHzWf) (:text |clockingConfigs)
                  |y $ %{} :Expr (:at 1712938927592) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713296835527) (:by |rJG4IHzWf) (:text |:image)
                      |b $ %{} :Leaf (:at 1713296833758) (:by |rJG4IHzWf) (:text |imageConfigs)
                  |z $ %{} :Expr (:at 1712938927592) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1714883754487) (:by |rJG4IHzWf) (:text |:ripple)
                      |b $ %{} :Leaf (:at 1714883759093) (:by |rJG4IHzWf) (:text |rippleConfigs)
                  |zD $ %{} :Expr (:at 1716718449053) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1716718460954) (:by |rJG4IHzWf) (:text |:surround-mirror)
                      |b $ %{} :Leaf (:at 1716718476124) (:by |rJG4IHzWf) (:text |surroundMirrorConfigs)
                  |zP $ %{} :Expr (:at 1716718449053) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1717260004166) (:by |rJG4IHzWf) (:text |:parallel-mirror)
                      |b $ %{} :Leaf (:at 1717260007417) (:by |rJG4IHzWf) (:text |parallelMirrorConfigs)
                  |zY $ %{} :Expr (:at 1716718449053) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1719132389274) (:by |rJG4IHzWf) (:text |:sphere-mirror)
                      |b $ %{} :Leaf (:at 1719132392722) (:by |rJG4IHzWf) (:text |sphereMirrorConfigs)
                  |ze $ %{} :Expr (:at 1716718449053) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1721236355611) (:by |rJG4IHzWf) (:text |:hollow-mirror)
                      |b $ %{} :Leaf (:at 1721236353122) (:by |rJG4IHzWf) (:text |hollowMirrorConfigs)
                  |zj $ %{} :Expr (:at 1716718449053) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1724345124486) (:by |rJG4IHzWf) (:text |:box-mirror)
                      |b $ %{} :Leaf (:at 1724345125986) (:by |rJG4IHzWf) (:text |boxMirrorConfigs)
                  |zn $ %{} :Expr (:at 1716718449053) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1731209263524) (:by |rJG4IHzWf) (:text |:rhombic-mirror)
                      |b $ %{} :Leaf (:at 1731209252849) (:by |rJG4IHzWf) (:text |rhombicMirrorConfigs)
        |load-textures! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1713297574685) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1713297574685) (:by |rJG4IHzWf) (:text |defn)
              |b $ %{} :Leaf (:at 1713297574685) (:by |rJG4IHzWf) (:text |load-textures!)
              |h $ %{} :Expr (:at 1713297574685) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1713297722040) (:by |rJG4IHzWf) (:text |device)
              |l $ %{} :Expr (:at 1713297577085) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1713297578904) (:by |rJG4IHzWf) (:text |hint-fn)
                  |b $ %{} :Leaf (:at 1713297579687) (:by |rJG4IHzWf) (:text |async)
              |o $ %{} :Expr (:at 1713891171686) (:by |rJG4IHzWf)
                :data $ {}
                  |D $ %{} :Leaf (:at 1713891172391) (:by |rJG4IHzWf) (:text |let)
                  |L $ %{} :Expr (:at 1713891172690) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Expr (:at 1713891172824) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891176111) (:by |rJG4IHzWf) (:text |img-tiye)
                          |b $ %{} :Expr (:at 1713891180928) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891180928) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1713891180928) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560582566) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560590017) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1713891180928) (:by |rJG4IHzWf) (:text "|\"https://cdn.tiye.me/logo/tiye.jpg")
                      |b $ %{} :Expr (:at 1713891191030) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891193910) (:by |rJG4IHzWf) (:text |img-candy)
                          |b $ %{} :Expr (:at 1744560654960) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891194303) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1713891194303) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560655987) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560656582) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1713891194303) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/c7367e21405d602c5ef5a8c55c35d512/candy.jpeg")
                      |h $ %{} :Expr (:at 1713891201938) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891203727) (:by |rJG4IHzWf) (:text |img-bubbles)
                          |b $ %{} :Expr (:at 1713891204315) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891204315) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1713891204315) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560657224) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560657888) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1713891204315) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/20b39957d952bd189e4253369db30335/pasted-2024-04-17T17:00:49.301Z.png")
                      |l $ %{} :Expr (:at 1713891216868) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891215426) (:by |rJG4IHzWf) (:text |img-rugs)
                          |b $ %{} :Expr (:at 1713891217583) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560658904) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560659604) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/ceec218462f81744323e22dd2d04e94b/pasted-2024-04-17T17:12:29.234Z.png")
                      |o $ %{} :Expr (:at 1713891216868) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1716576676907) (:by |rJG4IHzWf) (:text |img-pigment)
                          |b $ %{} :Expr (:at 1713891217583) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560660598) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560661201) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1716576679983) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/4a932a1d8eaf46b4d9d8ec07538e8ee1/pigment.jpg")
                      |q $ %{} :Expr (:at 1713891216868) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1716576687847) (:by |rJG4IHzWf) (:text |img-stripes)
                          |b $ %{} :Expr (:at 1713891217583) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1713891217583) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560665071) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560665623) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1716576689869) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/d090a685f03af9d31988a2a92b3b8a19/stripes.jpg")
                      |s $ %{} :Expr (:at 1744512978957) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744512982246) (:by |rJG4IHzWf) (:text |img-circles)
                          |b $ %{} :Expr (:at 1744512985635) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1744512985635) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1744512985635) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560666665) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560667379) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1744512995153) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/80e5932494210d46c600b402a029f973/circles.jpg")
                      |t $ %{} :Expr (:at 1744512978957) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744513006277) (:by |rJG4IHzWf) (:text |img-sparks)
                          |b $ %{} :Expr (:at 1744512985635) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1744512985635) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1744512985635) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560668554) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560669316) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1744513008446) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/3fd6b05f2f9b9a1985224ac39e7b3aee/sparks.jpg")
                      |u $ %{} :Expr (:at 1744512978957) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744517311138) (:by |rJG4IHzWf) (:text |img-rhombic)
                          |b $ %{} :Expr (:at 1744512985635) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1744512985635) (:by |rJG4IHzWf) (:text |solublejs/loadImageAsTexture)
                              |b $ %{} :Leaf (:at 1744512985635) (:by |rJG4IHzWf) (:text |device)
                              |h $ %{} :Expr (:at 1744560670382) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1744560671858) (:by |rJG4IHzWf) (:text |replace-url)
                                  |T $ %{} :Leaf (:at 1744517305853) (:by |rJG4IHzWf) (:text "|\"https://cos-sh.tiye.me/cos-up/309de8ad40b61cb865b32adedf1b2dc4/rhombic-mirror.png")
                  |T $ %{} :Expr (:at 1713297765380) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1713297784829) (:by |rJG4IHzWf) (:text |js-set)
                      |T $ %{} :Expr (:at 1713297580489) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1713297764729) (:by |rJG4IHzWf) (:text |.!deref)
                          |T $ %{} :Leaf (:at 1713297594631) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |b $ %{} :Leaf (:at 1713297786691) (:by |rJG4IHzWf) (:text "|\"tiye")
                      |h $ %{} :Expr (:at 1713373389195) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713373389195) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1713891183087) (:by |rJG4IHzWf) (:text |img-tiye)
                  |b $ %{} :Expr (:at 1713891220055) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891220055) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891220055) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891220055) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891220055) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1713891220055) (:by |rJG4IHzWf) (:text "|\"candy")
                      |l $ %{} :Expr (:at 1713891220055) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891220055) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1713891220055) (:by |rJG4IHzWf) (:text |img-candy)
                  |h $ %{} :Expr (:at 1713891221667) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891221667) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891221667) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891221667) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891221667) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1713891221667) (:by |rJG4IHzWf) (:text "|\"bubbles")
                      |l $ %{} :Expr (:at 1713891221667) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891221667) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1713891221667) (:by |rJG4IHzWf) (:text |img-bubbles)
                  |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text "|\"rugs")
                      |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |img-rugs)
                  |o $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1716576704541) (:by |rJG4IHzWf) (:text "|\"stripes")
                      |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1716576701153) (:by |rJG4IHzWf) (:text |img-stripes)
                  |q $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1716576716738) (:by |rJG4IHzWf) (:text "|\"pigment")
                      |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1716576713661) (:by |rJG4IHzWf) (:text |img-pigment)
                  |s $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1744513027213) (:by |rJG4IHzWf) (:text "|\"circles")
                      |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1744513029643) (:by |rJG4IHzWf) (:text |img-circles)
                  |t $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1744513032029) (:by |rJG4IHzWf) (:text "|\"sparks")
                      |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1744513034741) (:by |rJG4IHzWf) (:text |img-sparks)
                  |u $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-set)
                      |b $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |.!deref)
                          |b $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                      |h $ %{} :Leaf (:at 1744513039461) (:by |rJG4IHzWf) (:text "|\"yulan")
                      |l $ %{} :Expr (:at 1713891224558) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713891224558) (:by |rJG4IHzWf) (:text |js-await)
                          |b $ %{} :Leaf (:at 1744517314041) (:by |rJG4IHzWf) (:text |img-rhombic)
        |loop-paint! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1699464116175) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1699464116175) (:by |rJG4IHzWf) (:text |defn)
              |b $ %{} :Leaf (:at 1699464116175) (:by |rJG4IHzWf) (:text |loop-paint!)
              |h $ %{} :Expr (:at 1699464116175) (:by |rJG4IHzWf)
                :data $ {}
              |l $ %{} :Expr (:at 1713006047259) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1713006047259) (:by |rJG4IHzWf) (:text |solublejs/callFramePaint)
              |q $ %{} :Expr (:at 1709315080619) (:by |rJG4IHzWf)
                :data $ {}
                  |D $ %{} :Leaf (:at 1709315081130) (:by |rJG4IHzWf) (:text |if)
                  |L $ %{} :Expr (:at 1709315082860) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709315082577) (:by |rJG4IHzWf) (:text |>)
                      |b $ %{} :Leaf (:at 1709315084503) (:by |rJG4IHzWf) (:text |config/interval)
                      |h $ %{} :Leaf (:at 1709315085072) (:by |rJG4IHzWf) (:text |10)
                  |T $ %{} :Expr (:at 1699464162514) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1699464368572) (:by |rJG4IHzWf) (:text |reset!)
                      |T $ %{} :Leaf (:at 1699464170378) (:by |rJG4IHzWf) (:text |*timeout)
                      |b $ %{} :Expr (:at 1699464187923) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1713003001708) (:by |rJG4IHzWf) (:text |flipped)
                          |T $ %{} :Leaf (:at 1699464191876) (:by |rJG4IHzWf) (:text |js/setTimeout)
                          |X $ %{} :Leaf (:at 1713003004077) (:by |rJG4IHzWf) (:text |config/interval)
                          |b $ %{} :Expr (:at 1699464193072) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699464193373) (:by |rJG4IHzWf) (:text |fn)
                              |b $ %{} :Expr (:at 1699464193725) (:by |rJG4IHzWf)
                                :data $ {}
                              |h $ %{} :Expr (:at 1699464194919) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699464200921) (:by |rJG4IHzWf) (:text |reset!)
                                  |b $ %{} :Leaf (:at 1699464204386) (:by |rJG4IHzWf) (:text |*raf)
                                  |h $ %{} :Expr (:at 1699464210293) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1699464374397) (:by |rJG4IHzWf) (:text |js/requestAnimationFrame)
                                      |X $ %{} :Expr (:at 1699464584138) (:by |rJG4IHzWf)
                                        :data $ {}
                                          |T $ %{} :Leaf (:at 1699464584418) (:by |rJG4IHzWf) (:text |fn)
                                          |b $ %{} :Expr (:at 1699464584737) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1699464586235) (:by |rJG4IHzWf) (:text |t)
                                          |h $ %{} :Expr (:at 1699464588834) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1699464588622) (:by |rJG4IHzWf) (:text |loop-paint!)
                  |b $ %{} :Expr (:at 1709315088844) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1709315088844) (:by |rJG4IHzWf) (:text |reset!)
                      |b $ %{} :Leaf (:at 1709315088844) (:by |rJG4IHzWf) (:text |*raf)
                      |h $ %{} :Expr (:at 1709315088844) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1709315088844) (:by |rJG4IHzWf) (:text |js/requestAnimationFrame)
                          |b $ %{} :Expr (:at 1709315088844) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1709315088844) (:by |rJG4IHzWf) (:text |fn)
                              |b $ %{} :Expr (:at 1709315088844) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1709315088844) (:by |rJG4IHzWf) (:text |t)
                              |h $ %{} :Expr (:at 1709315088844) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1709315088844) (:by |rJG4IHzWf) (:text |loop-paint!)
        |main! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |defn)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |main!)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
              |s $ %{} :Expr (:at 1699463879026) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463880500) (:by |rJG4IHzWf) (:text |hint-fn)
                  |b $ %{} :Leaf (:at 1699463881240) (:by |rJG4IHzWf) (:text |async)
              |sD $ %{} :Expr (:at 1699463954200) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463955556) (:by |rJG4IHzWf) (:text |println)
                  |b $ %{} :Leaf (:at 1699463955556) (:by |rJG4IHzWf) (:text "|\"Running mode:")
                  |h $ %{} :Expr (:at 1699463955556) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463955556) (:by |rJG4IHzWf) (:text |if)
                      |b $ %{} :Leaf (:at 1699463955556) (:by |rJG4IHzWf) (:text |config/dev?)
                      |h $ %{} :Leaf (:at 1699463955556) (:by |rJG4IHzWf) (:text "|\"dev")
                      |l $ %{} :Leaf (:at 1699463955556) (:by |rJG4IHzWf) (:text "|\"release")
              |sL $ %{} :Expr (:at 1699463959462) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463959462) (:by |rJG4IHzWf) (:text |if)
                  |b $ %{} :Leaf (:at 1699463959462) (:by |rJG4IHzWf) (:text |config/dev?)
                  |h $ %{} :Expr (:at 1699463959462) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463959462) (:by |rJG4IHzWf) (:text |load-console-formatter!)
              |sP $ %{} :Expr (:at 1713297811065) (:by |rJG4IHzWf)
                :data $ {}
                  |D $ %{} :Leaf (:at 1713297811679) (:by |rJG4IHzWf) (:text |let)
                  |T $ %{} :Expr (:at 1713297812816) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Expr (:at 1713297813301) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1713297814004) (:by |rJG4IHzWf) (:text |ret)
                          |P $ %{} :Expr (:at 1713298456936) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1713298463361) (:by |rJG4IHzWf) (:text |js-await)
                              |T $ %{} :Expr (:at 1713298342630) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1713298342630) (:by |rJG4IHzWf) (:text |solublejs/initializeContext)
                      |b $ %{} :Expr (:at 1744515730497) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1744515731628) (:by |rJG4IHzWf) (:text |device)
                          |b $ %{} :Expr (:at 1744515733922) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1744515733922) (:by |rJG4IHzWf) (:text |.-device)
                              |b $ %{} :Leaf (:at 1744515733922) (:by |rJG4IHzWf) (:text |ret)
                  |b $ %{} :Expr (:at 1713891011301) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1713891011862) (:by |rJG4IHzWf) (:text |if)
                      |L $ %{} :Expr (:at 1713891012743) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1717002602380) (:by |rJG4IHzWf) (:text |contains?)
                          |X $ %{} :Expr (:at 1717002636220) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1717002638887) (:by |rJG4IHzWf) (:text |#{})
                              |b $ %{} :Leaf (:at 1717002639327) (:by |rJG4IHzWf) (:text |:image)
                              |h $ %{} :Leaf (:at 1717002642048) (:by |rJG4IHzWf) (:text |:surround-mirror)
                              |l $ %{} :Expr (:at 1719334954137) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1719334955699) (:by |rJG4IHzWf) (:text |;)
                                  |T $ %{} :Leaf (:at 1719137088264) (:by |rJG4IHzWf) (:text |:sphere-mirror)
                          |b $ %{} :Expr (:at 1713891032978) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1713891036901) (:by |rJG4IHzWf) (:text |->)
                              |T $ %{} :Leaf (:at 1713891035950) (:by |rJG4IHzWf) (:text |@*reel)
                              |b $ %{} :Leaf (:at 1713891038406) (:by |rJG4IHzWf) (:text |:store)
                              |h $ %{} :Leaf (:at 1713891047230) (:by |rJG4IHzWf) (:text |:tab)
                      |T $ %{} :Expr (:at 1744515834768) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1744515835362) (:by |rJG4IHzWf) (:text |do)
                          |T $ %{} :Expr (:at 1713298339003) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713298339003) (:by |rJG4IHzWf) (:text |js-await)
                              |b $ %{} :Expr (:at 1713298339003) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1713298339003) (:by |rJG4IHzWf) (:text |load-textures!)
                                  |b $ %{} :Leaf (:at 1744515735958) (:by |rJG4IHzWf) (:text |device)
                          |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |js/window.addEventListener)
                              |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text "|\"keydown")
                              |h $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |fn)
                                  |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |event)
                                  |h $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |hint-fn)
                                      |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |async)
                                  |l $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |js/console.log)
                                      |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |event)
                                  |o $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |if)
                                      |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                        :data $ {}
                                          |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |and)
                                          |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |or)
                                              |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |.-metaKey)
                                                  |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |event)
                                              |h $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |.-ctrlKey)
                                                  |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |event)
                                          |h $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |=)
                                              |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text "|\"b")
                                              |h $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |.-key)
                                                  |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |event)
                                      |h $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                        :data $ {}
                                          |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |let)
                                          |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1744515865456) (:by |rJG4IHzWf) (:text |texture)
                                                  |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                                    :data $ {}
                                                      |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |js-await)
                                                      |b $ %{} :Expr (:at 1744515836411) (:by |rJG4IHzWf)
                                                        :data $ {}
                                                          |T $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |solublejs/loadImageFromInputEl)
                                                          |b $ %{} :Leaf (:at 1744515836411) (:by |rJG4IHzWf) (:text |device)
                                              |b $ %{} :Expr (:at 1744516196647) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1744516198425) (:by |rJG4IHzWf) (:text |k)
                                                  |b $ %{} :Expr (:at 1744516199159) (:by |rJG4IHzWf)
                                                    :data $ {}
                                                      |T $ %{} :Leaf (:at 1744516199159) (:by |rJG4IHzWf) (:text |img-slot!)
                                          |l $ %{} :Expr (:at 1744516122554) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |5 $ %{} :Leaf (:at 1744516179718) (:by |rJG4IHzWf) (:text |js-set)
                                              |D $ %{} :Expr (:at 1744516255931) (:by |rJG4IHzWf)
                                                :data $ {}
                                                  |T $ %{} :Leaf (:at 1744516255931) (:by |rJG4IHzWf) (:text |.!deref)
                                                  |b $ %{} :Leaf (:at 1744516255931) (:by |rJG4IHzWf) (:text |solublejs/atomSharedTextures)
                                              |P $ %{} :Leaf (:at 1744516195041) (:by |rJG4IHzWf) (:text |k)
                                              |b $ %{} :Leaf (:at 1744516182388) (:by |rJG4IHzWf) (:text |texture)
                                          |o $ %{} :Expr (:at 1744516201125) (:by |rJG4IHzWf)
                                            :data $ {}
                                              |T $ %{} :Leaf (:at 1744516203428) (:by |rJG4IHzWf) (:text |js/console.log)
                                              |b $ %{} :Leaf (:at 1744516214878) (:by |rJG4IHzWf) (:text "|\"image added to slot")
                                              |h $ %{} :Leaf (:at 1744516211845) (:by |rJG4IHzWf) (:text |k)
                      |b $ %{} :Expr (:at 1713891119519) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1713891395591) (:by |rJG4IHzWf) (:text |do)
                          |T $ %{} :Expr (:at 1713891055500) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713891055500) (:by |rJG4IHzWf) (:text |load-textures!)
                              |b $ %{} :Leaf (:at 1744515738996) (:by |rJG4IHzWf) (:text |device)
                          |b $ %{} :Leaf (:at 1713891396724) (:by |rJG4IHzWf) (:text |nil)
              |x $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |render-app!)
              |xT $ %{} :Expr (:at 1699464107043) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699464112278) (:by |rJG4IHzWf) (:text |loop-paint!)
              |xr $ %{} :Expr (:at 1699464257411) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1713005588806) (:by |rJG4IHzWf) (:text |solublejs/resetCanvasHeight)
                  |b $ %{} :Leaf (:at 1699464258970) (:by |rJG4IHzWf) (:text |canvas)
              |xv $ %{} :Expr (:at 1699464277328) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699464293560) (:by |rJG4IHzWf) (:text |js/window.addEventListener)
                  |b $ %{} :Leaf (:at 1699464299816) (:by |rJG4IHzWf) (:text "|\"resize")
                  |h $ %{} :Expr (:at 1699464300185) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699464300425) (:by |rJG4IHzWf) (:text |fn)
                      |b $ %{} :Expr (:at 1699464300733) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699464301429) (:by |rJG4IHzWf) (:text |event)
                      |h $ %{} :Expr (:at 1699464307084) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713005581066) (:by |rJG4IHzWf) (:text |solublejs/resetCanvasHeight)
                          |b $ %{} :Leaf (:at 1699464308422) (:by |rJG4IHzWf) (:text |canvas)
                      |l $ %{} :Expr (:at 1699464309598) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713005583538) (:by |rJG4IHzWf) (:text |solublejs/paintSolubleTree)
              |xy $ %{} :Expr (:at 1709143935396) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1713005704161) (:by |rJG4IHzWf) (:text |solublejs/loadGamepadControl)
                  |b $ %{} :Expr (:at 1713001531656) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713001531893) (:by |rJG4IHzWf) (:text |fn)
                      |b $ %{} :Expr (:at 1713001532159) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713001533873) (:by |rJG4IHzWf) (:text |events)
                      |h $ %{} :Expr (:at 1713001534365) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713002290718) (:by |rJG4IHzWf) (:text |if-let)
                          |b $ %{} :Expr (:at 1713002286910) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713002286459) (:by |rJG4IHzWf) (:text |f)
                              |b $ %{} :Expr (:at 1713002293147) (:by |rJG4IHzWf)
                                :data $ {}
                                  |D $ %{} :Leaf (:at 1713002296848) (:by |rJG4IHzWf) (:text |.-onButtonEvent)
                                  |T $ %{} :Expr (:at 1713001812165) (:by |rJG4IHzWf)
                                    :data $ {}
                                      |D $ %{} :Leaf (:at 1713001818089) (:by |rJG4IHzWf) (:text |.-value)
                                      |T $ %{} :Leaf (:at 1713002189042) (:by |rJG4IHzWf) (:text |atomSolubleTree)
                          |h $ %{} :Expr (:at 1713002297887) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1713002298266) (:by |rJG4IHzWf) (:text |f)
                              |b $ %{} :Leaf (:at 1713002299467) (:by |rJG4IHzWf) (:text |events)
              |y $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |add-watch)
                  |j $ %{} :Leaf (:at 1507399915531) (:by |root) (:text |*reel)
                  |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:changes)
                  |v $ %{} :Expr (:at 1499755354983) (:by nil)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |fn)
                      |j $ %{} :Expr (:at 1499755354983) (:by nil)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1612280609284) (:by |rJG4IHzWf) (:text |reel)
                          |j $ %{} :Leaf (:at 1612280610651) (:by |rJG4IHzWf) (:text |prev)
                      |r $ %{} :Expr (:at 1499755354983) (:by nil)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |render-app!)
              |yD $ %{} :Expr (:at 1507461684494) (:by |root)
                :data $ {}
                  |T $ %{} :Leaf (:at 1507461739167) (:by |root) (:text |listen-devtools!)
                  |j $ %{} :Leaf (:at 1624007376825) (:by |rJG4IHzWf) (:text ||k)
                  |r $ %{} :Leaf (:at 1507461693919) (:by |root) (:text |dispatch!)
              |yL $ %{} :Expr (:at 1518157357847) (:by |root)
                :data $ {}
                  |j $ %{} :Leaf (:at 1646150136497) (:by |rJG4IHzWf) (:text |js/window.addEventListener)
                  |r $ %{} :Leaf (:at 1518157458163) (:by |root) (:text ||beforeunload)
                  |v $ %{} :Expr (:at 1612344221583) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1612344222204) (:by |rJG4IHzWf) (:text |fn)
                      |L $ %{} :Expr (:at 1612344222530) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1612344223520) (:by |rJG4IHzWf) (:text |event)
                      |T $ %{} :Expr (:at 1612344224533) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1533919515671) (:by |rJG4IHzWf) (:text |persist-storage!)
              |yM $ %{} :Expr (:at 1518157357847) (:by |root)
                :data $ {}
                  |j $ %{} :Leaf (:at 1646150136497) (:by |rJG4IHzWf) (:text |js/window.addEventListener)
                  |r $ %{} :Leaf (:at 1695833113543) (:by |rJG4IHzWf) (:text ||visibilitychange)
                  |v $ %{} :Expr (:at 1612344221583) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1612344222204) (:by |rJG4IHzWf) (:text |fn)
                      |L $ %{} :Expr (:at 1612344222530) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1612344223520) (:by |rJG4IHzWf) (:text |event)
                      |T $ %{} :Expr (:at 1695833124329) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1695833125950) (:by |rJG4IHzWf) (:text |if)
                          |L $ %{} :Expr (:at 1695833126511) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1695833145858) (:by |rJG4IHzWf) (:text |=)
                              |L $ %{} :Leaf (:at 1695833179425) (:by |rJG4IHzWf) (:text "|\"hidden")
                              |T $ %{} :Leaf (:at 1695833167249) (:by |rJG4IHzWf) (:text |js/document.visibilityState)
                          |T $ %{} :Expr (:at 1612344224533) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1533919515671) (:by |rJG4IHzWf) (:text |persist-storage!)
              |yO $ %{} :Expr (:at 1646150039456) (:by |rJG4IHzWf)
                :data $ {}
                  |5 $ %{} :Leaf (:at 1716718960690) (:by |rJG4IHzWf) (:text |;)
                  |D $ %{} :Leaf (:at 1646150045747) (:by |rJG4IHzWf) (:text |flipped)
                  |T $ %{} :Leaf (:at 1646150042154) (:by |rJG4IHzWf) (:text |js/setInterval)
                  |b $ %{} :Leaf (:at 1646150175987) (:by |rJG4IHzWf) (:text |60000)
                  |h $ %{} :Leaf (:at 1646150050057) (:by |rJG4IHzWf) (:text |persist-storage!)
              |yP $ %{} :Expr (:at 1518157492640) (:by |root)
                :data $ {}
                  |D $ %{} :Leaf (:at 1711260045196) (:by |rJG4IHzWf) (:text |;)
                  |T $ %{} :Leaf (:at 1518157495438) (:by |root) (:text |let)
                  |j $ %{} :Expr (:at 1518157495644) (:by |root)
                    :data $ {}
                      |T $ %{} :Expr (:at 1518157495826) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1518157496930) (:by |root) (:text |raw)
                          |j $ %{} :Expr (:at 1518157497615) (:by |root)
                            :data $ {}
                              |j $ %{} :Leaf (:at 1646150065132) (:by |rJG4IHzWf) (:text |js/localStorage.getItem)
                              |r $ %{} :Expr (:at 1518157506313) (:by |root)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1544956709260) (:by |rJG4IHzWf) (:text |:storage-key)
                                  |j $ %{} :Leaf (:at 1527788293499) (:by |root) (:text |config/site)
                  |r $ %{} :Expr (:at 1518157514334) (:by |root)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1533919640958) (:by |rJG4IHzWf) (:text |when)
                      |j $ %{} :Expr (:at 1518157515117) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1518157515786) (:by |root) (:text |some?)
                          |j $ %{} :Leaf (:at 1518157516878) (:by |root) (:text |raw)
                      |r $ %{} :Expr (:at 1518157521635) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1518157523818) (:by |root) (:text |dispatch!)
                          |j $ %{} :Expr (:at 1688397806134) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1688397806833) (:by |rJG4IHzWf) (:text |::)
                              |T $ %{} :Leaf (:at 1518157669936) (:by |root) (:text |:hydrate-storage)
                              |b $ %{} :Expr (:at 1688397811073) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1688397811073) (:by |rJG4IHzWf) (:text |parse-cirru-edn)
                                  |b $ %{} :Leaf (:at 1688397811073) (:by |rJG4IHzWf) (:text |raw)
              |yT $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |println)
                  |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text "||App started.")
        |mount-target $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |def)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |mount-target)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |j $ %{} :Leaf (:at 1695659910770) (:by |rJG4IHzWf) (:text |js/document.querySelector)
                  |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text ||.app)
        |persist-storage! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1533919515671) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1533919517365) (:by |rJG4IHzWf) (:text |defn)
              |j $ %{} :Leaf (:at 1533919515671) (:by |rJG4IHzWf) (:text |persist-storage!)
              |n $ %{} :Expr (:at 1646150052705) (:by |rJG4IHzWf)
                :data $ {}
              |r $ %{} :Expr (:at 1646150152124) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1695833186592) (:by |rJG4IHzWf) (:text |println)
                  |b $ %{} :Leaf (:at 1695833194980) (:by |rJG4IHzWf) (:text "|\"Saved at")
                  |e $ %{} :Expr (:at 1695833205162) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1695833211484) (:by |rJG4IHzWf) (:text |.!toISOString)
                      |T $ %{} :Expr (:at 1695833196620) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1695833204629) (:by |rJG4IHzWf) (:text |new)
                          |T $ %{} :Leaf (:at 1695833201386) (:by |rJG4IHzWf) (:text |js/Date)
              |v $ %{} :Expr (:at 1533919515671) (:by |rJG4IHzWf)
                :data $ {}
                  |j $ %{} :Leaf (:at 1646150150852) (:by |rJG4IHzWf) (:text |js/localStorage.setItem)
                  |r $ %{} :Expr (:at 1533919515671) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1544956703087) (:by |rJG4IHzWf) (:text |:storage-key)
                      |j $ %{} :Leaf (:at 1533919515671) (:by |rJG4IHzWf) (:text |config/site)
                  |v $ %{} :Expr (:at 1533919515671) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1624469402829) (:by |rJG4IHzWf) (:text |format-cirru-edn)
                      |j $ %{} :Expr (:at 1533919515671) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1533919515671) (:by |rJG4IHzWf) (:text |:store)
                          |j $ %{} :Leaf (:at 1533919515671) (:by |rJG4IHzWf) (:text |@*reel)
        |reload! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1626201152815) (:by |rJG4IHzWf)
            :data $ {}
              |D $ %{} :Leaf (:at 1626201153853) (:by |rJG4IHzWf) (:text |defn)
              |L $ %{} :Leaf (:at 1626201157449) (:by |rJG4IHzWf) (:text |reload!)
              |P $ %{} :Expr (:at 1626201163076) (:by |rJG4IHzWf)
                :data $ {}
              |T $ %{} :Expr (:at 1626201191606) (:by |rJG4IHzWf)
                :data $ {}
                  |D $ %{} :Leaf (:at 1626201192115) (:by |rJG4IHzWf) (:text |if)
                  |L $ %{} :Expr (:at 1626201192626) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1626201534497) (:by |rJG4IHzWf) (:text |nil?)
                      |j $ %{} :Leaf (:at 1626201194806) (:by |rJG4IHzWf) (:text |build-errors)
                  |T $ %{} :Expr (:at 1626201164538) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1626201161775) (:by |rJG4IHzWf) (:text |do)
                      |j $ %{} :Expr (:at 1614750747553) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1614750747553) (:by |rJG4IHzWf) (:text |remove-watch)
                          |j $ %{} :Leaf (:at 1614750747553) (:by |rJG4IHzWf) (:text |*reel)
                          |r $ %{} :Leaf (:at 1614750747553) (:by |rJG4IHzWf) (:text |:changes)
                      |n $ %{} :Expr (:at 1709660884872) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1713005681694) (:by |rJG4IHzWf) (:text |solublejs/clearPointsBuffer)
                      |r $ %{} :Expr (:at 1507461699387) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1507461702453) (:by |root) (:text |clear-cache!)
                      |v $ %{} :Expr (:at 1612280627439) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |add-watch)
                          |j $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |*reel)
                          |r $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |:changes)
                          |v $ %{} :Expr (:at 1612280627439) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |fn)
                              |j $ %{} :Expr (:at 1612280627439) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |reel)
                                  |j $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |prev)
                              |r $ %{} :Expr (:at 1612280627439) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1612280627439) (:by |rJG4IHzWf) (:text |render-app!)
                      |vT $ %{} :Expr (:at 1709660318285) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1709660334383) (:by |rJG4IHzWf) (:text |js/cancelAnimationFrame)
                          |T $ %{} :Leaf (:at 1709660323400) (:by |rJG4IHzWf) (:text |@*raf)
                      |w $ %{} :Expr (:at 1709658873188) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1709658873188) (:by |rJG4IHzWf) (:text |render-app!)
                      |wT $ %{} :Expr (:at 1709660347660) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1709660354536) (:by |rJG4IHzWf) (:text |loop-paint!)
                      |x $ %{} :Expr (:at 1507461704162) (:by |root)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1507461706990) (:by |root) (:text |reset!)
                          |j $ %{} :Leaf (:at 1507461708965) (:by |root) (:text |*reel)
                          |r $ %{} :Expr (:at 1507461710020) (:by |root)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1507461730190) (:by |root) (:text |refresh-reel)
                              |j $ %{} :Leaf (:at 1507461719097) (:by |root) (:text |@*reel)
                              |r $ %{} :Leaf (:at 1507461721870) (:by |root) (:text |schema/store)
                              |v $ %{} :Leaf (:at 1507461722724) (:by |root) (:text |updater)
                      |y $ %{} :Expr (:at 1626777542168) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1626777542168) (:by |rJG4IHzWf) (:text |hud!)
                          |j $ %{} :Leaf (:at 1626777542168) (:by |rJG4IHzWf) (:text "|\"ok~")
                          |r $ %{} :Leaf (:at 1679237703306) (:by |rJG4IHzWf) (:text "|\"Ok")
                  |j $ %{} :Expr (:at 1626201203433) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1626290831868) (:by |rJG4IHzWf) (:text |hud!)
                      |b $ %{} :Leaf (:at 1626290930377) (:by |rJG4IHzWf) (:text "|\"error")
                      |j $ %{} :Leaf (:at 1626201209903) (:by |rJG4IHzWf) (:text |build-errors)
        |render-app! $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |defn)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |render-app!)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
              |t $ %{} :Expr (:at 1699463691422) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1699463751512) (:by |rJG4IHzWf) (:text |let)
                  |X $ %{} :Expr (:at 1699463752036) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Expr (:at 1699463752202) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1699463753484) (:by |rJG4IHzWf) (:text |tab)
                          |T $ %{} :Expr (:at 1699463704698) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1699463710854) (:by |rJG4IHzWf) (:text |:tab)
                              |T $ %{} :Expr (:at 1699463703009) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1699463703009) (:by |rJG4IHzWf) (:text |:store)
                                  |b $ %{} :Leaf (:at 1699463715425) (:by |rJG4IHzWf) (:text |@*reel)
                      |b $ %{} :Expr (:at 1699463981433) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463987681) (:by |rJG4IHzWf) (:text |app-config)
                          |b $ %{} :Expr (:at 1699463988233) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1699463989674) (:by |rJG4IHzWf) (:text |get-app)
                              |b $ %{} :Leaf (:at 1699463991379) (:by |rJG4IHzWf) (:text |tab)
                  |a $ %{} :Expr (:at 1699464031393) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1699464040679) (:by |rJG4IHzWf) (:text |.!initPointsBuffer)
                      |T $ %{} :Leaf (:at 1699464034257) (:by |rJG4IHzWf) (:text |app-config)
                  |e $ %{} :Expr (:at 1699463755088) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1713005611655) (:by |rJG4IHzWf) (:text |solublejs/renderSolubleTree)
                      |X $ %{} :Leaf (:at 1713004178561) (:by |rJG4IHzWf) (:text |app-config)
              |v $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1624469436438) (:by |rJG4IHzWf) (:text |render!)
                  |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |mount-target)
                  |r $ %{} :Expr (:at 1499755354983) (:by nil)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |comp-container)
                      |j $ %{} :Leaf (:at 1507400119272) (:by |root) (:text |@*reel)
                  |v $ %{} :Leaf (:at 1623915174985) (:by |rJG4IHzWf) (:text |dispatch!)
        |replace-url $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1744560590937) (:by |rJG4IHzWf)
            :data $ {}
              |T $ %{} :Leaf (:at 1744560592060) (:by |rJG4IHzWf) (:text |defn)
              |b $ %{} :Leaf (:at 1744560590937) (:by |rJG4IHzWf) (:text |replace-url)
              |h $ %{} :Expr (:at 1744560590937) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1744560595754) (:by |rJG4IHzWf) (:text |url)
              |l $ %{} :Expr (:at 1744560599502) (:by |rJG4IHzWf)
                :data $ {}
                  |T $ %{} :Leaf (:at 1744560599960) (:by |rJG4IHzWf) (:text |if)
                  |b $ %{} :Expr (:at 1744560604232) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1744560605256) (:by |rJG4IHzWf) (:text |some?)
                      |T $ %{} :Leaf (:at 1744560602527) (:by |rJG4IHzWf) (:text |config/resource-base-url)
                  |h $ %{} :Expr (:at 1744560638870) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1744560639677) (:by |rJG4IHzWf) (:text |str)
                      |L $ %{} :Leaf (:at 1744560642515) (:by |rJG4IHzWf) (:text |config/resource-base-url)
                      |P $ %{} :Leaf (:at 1744560646542) (:by |rJG4IHzWf) (:text "|\"/")
                      |T $ %{} :Expr (:at 1744560633827) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1744560634673) (:by |rJG4IHzWf) (:text |last)
                          |T $ %{} :Expr (:at 1744560606839) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1744560627862) (:by |rJG4IHzWf) (:text |.split)
                              |X $ %{} :Leaf (:at 1744560630219) (:by |rJG4IHzWf) (:text |url)
                              |b $ %{} :Leaf (:at 1744560631702) (:by |rJG4IHzWf) (:text "|\"/")
                  |l $ %{} :Leaf (:at 1744560652025) (:by |rJG4IHzWf) (:text |url)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1499755354983) (:by nil)
          :data $ {}
            |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |ns)
            |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |app.main)
            |r $ %{} :Expr (:at 1499755354983) (:by nil)
              :data $ {}
                |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:require)
                |j $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |respo.core)
                    |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1499755354983) (:by nil)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |render!)
                        |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |clear-cache!)
                |v $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |app.comp.container)
                    |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1499755354983) (:by nil)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |comp-container)
                |y $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1508556737455) (:by |root) (:text |app.updater)
                    |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1499755354983) (:by nil)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |updater)
                |yT $ %{} :Expr (:at 1499755354983) (:by nil)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |app.schema)
                    |r $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:as)
                    |v $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |schema)
                |yj $ %{} :Expr (:at 1507399674125) (:by |root)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1507399678694) (:by |root) (:text |reel.util)
                    |r $ %{} :Leaf (:at 1507399680625) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1507399680857) (:by |root)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1518156292092) (:by |root) (:text |listen-devtools!)
                |yr $ %{} :Expr (:at 1507399683930) (:by |root)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1507399687162) (:by |root) (:text |reel.core)
                    |r $ %{} :Leaf (:at 1507399688098) (:by |root) (:text |:refer)
                    |v $ %{} :Expr (:at 1507399688322) (:by |root)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1507399691010) (:by |root) (:text |reel-updater)
                        |q $ %{} :Leaf (:at 1518156288482) (:by |root) (:text |refresh-reel)
                |yv $ %{} :Expr (:at 1507399715229) (:by |root)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1507399717674) (:by |root) (:text |reel.schema)
                    |r $ %{} :Leaf (:at 1507399755750) (:by |root) (:text |:as)
                    |v $ %{} :Leaf (:at 1507399757678) (:by |root) (:text |reel-schema)
                |yy $ %{} :Expr (:at 1527788302920) (:by |root)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1527788304925) (:by |root) (:text |app.config)
                    |r $ %{} :Leaf (:at 1527788306048) (:by |root) (:text |:as)
                    |v $ %{} :Leaf (:at 1527788306884) (:by |root) (:text |config)
                |yyT $ %{} :Expr (:at 1626201173819) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1626201180939) (:by |rJG4IHzWf) (:text "|\"./calcit.build-errors")
                    |j $ %{} :Leaf (:at 1626201183958) (:by |rJG4IHzWf) (:text |:default)
                    |r $ %{} :Leaf (:at 1626201187310) (:by |rJG4IHzWf) (:text |build-errors)
                |yyj $ %{} :Expr (:at 1626290808117) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1626290810913) (:by |rJG4IHzWf) (:text "|\"bottom-tip")
                    |j $ %{} :Leaf (:at 1626290816153) (:by |rJG4IHzWf) (:text |:default)
                    |r $ %{} :Leaf (:at 1626290825711) (:by |rJG4IHzWf) (:text |hud!)
                |zB $ %{} :Expr (:at 1713005537384) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961030464) (:by |rJG4IHzWf) (:text "|\"../src/index.mts")
                    |b $ %{} :Leaf (:at 1713005541648) (:by |rJG4IHzWf) (:text |:as)
                    |h $ %{} :Leaf (:at 1713005549093) (:by |rJG4IHzWf) (:text |solublejs)
                |zP $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961028933) (:by |rJG4IHzWf) (:text "|\"../src/apps/cubic-fire.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699464560849) (:by |rJG4IHzWf) (:text |cubicFireConfigs)
                |zY $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961027546) (:by |rJG4IHzWf) (:text "|\"../src/apps/quaternion-fractal.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699464631123) (:by |rJG4IHzWf) (:text |quaternionFractalConfigs)
                |ze $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961025795) (:by |rJG4IHzWf) (:text "|\"../src/apps/complex-fractal.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699464653125) (:by |rJG4IHzWf) (:text |complexFractalConfigs)
                |zg $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961023705) (:by |rJG4IHzWf) (:text "|\"../src/apps/newton.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1722186769756) (:by |rJG4IHzWf) (:text |newtonFractalConfigs)
                |zh $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961021837) (:by |rJG4IHzWf) (:text "|\"../src/apps/newton-cosh.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1722621221510) (:by |rJG4IHzWf) (:text |newtonCoshFractalConfigs)
                |zj $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961020522) (:by |rJG4IHzWf) (:text "|\"../src/apps/space-fractal.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699464661741) (:by |rJG4IHzWf) (:text |spaceFractalConfigs)
                |zn $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961019233) (:by |rJG4IHzWf) (:text "|\"../src/apps/sphere-fractal.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699464670237) (:by |rJG4IHzWf) (:text |sphereFractalConfigs)
                |zq $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961017970) (:by |rJG4IHzWf) (:text "|\"../src/apps/slow-fractal.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1699464679191) (:by |rJG4IHzWf) (:text |slowFractalConfigs)
                |zs $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961016396) (:by |rJG4IHzWf) (:text "|\"../src/apps/orbits.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1709313859906) (:by |rJG4IHzWf) (:text |orbitsConfigs)
                |zsD $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961014664) (:by |rJG4IHzWf) (:text "|\"../src/apps/kaleidoscope.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1712938794112) (:by |rJG4IHzWf) (:text |kaleidoscopeConfigs)
                |zsH $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961013166) (:by |rJG4IHzWf) (:text "|\"../src/apps/kaleidoscope-mirror.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1722106713410) (:by |rJG4IHzWf) (:text |kaleidoscopeMirrorConfigs)
                |zsL $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961011780) (:by |rJG4IHzWf) (:text "|\"../src/apps/image.mts")
                    |b $ %{} :Leaf (:at 1699464556816) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1699464561369) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1713296827330) (:by |rJG4IHzWf) (:text |imageConfigs)
                |zsT $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961010589) (:by |rJG4IHzWf) (:text "|\"../src/apps/stars.mts")
                    |a $ %{} :Leaf (:at 1709658652379) (:by |rJG4IHzWf) (:text |:as)
                    |g $ %{} :Leaf (:at 1709658654167) (:by |rJG4IHzWf) (:text |stars)
                |zsj $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961009257) (:by |rJG4IHzWf) (:text "|\"../src/apps/rings.mts")
                    |a $ %{} :Leaf (:at 1709658652379) (:by |rJG4IHzWf) (:text |:as)
                    |g $ %{} :Leaf (:at 1710871546430) (:by |rJG4IHzWf) (:text |rings)
                |zsr $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961007896) (:by |rJG4IHzWf) (:text "|\"../src/apps/circles.mts")
                    |a $ %{} :Leaf (:at 1709658652379) (:by |rJG4IHzWf) (:text |:as)
                    |g $ %{} :Leaf (:at 1711166659086) (:by |rJG4IHzWf) (:text |circles)
                |zsv $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961006653) (:by |rJG4IHzWf) (:text "|\"../src/apps/clocking.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1714755654538) (:by |rJG4IHzWf) (:text |clockingConfigs)
                |zsx $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961005439) (:by |rJG4IHzWf) (:text "|\"../src/apps/ripple.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1714883764074) (:by |rJG4IHzWf) (:text |rippleConfigs)
                |zsy $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961003320) (:by |rJG4IHzWf) (:text "|\"../src/apps/surround-mirror.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1716718481604) (:by |rJG4IHzWf) (:text |surroundMirrorConfigs)
                |zsz $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961002172) (:by |rJG4IHzWf) (:text "|\"../src/apps/parallel-mirror.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1717259997421) (:by |rJG4IHzWf) (:text |parallelMirrorConfigs)
                |zszD $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736961000740) (:by |rJG4IHzWf) (:text "|\"../src/apps/sphere-mirror.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1719132398736) (:by |rJG4IHzWf) (:text |sphereMirrorConfigs)
                |zszP $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736960999358) (:by |rJG4IHzWf) (:text "|\"../src/apps/hollow-mirror.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1721236343369) (:by |rJG4IHzWf) (:text |hollowMirrorConfigs)
                |zszY $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736960992026) (:by |rJG4IHzWf) (:text "|\"../src/apps/box-mirror.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1724345131767) (:by |rJG4IHzWf) (:text |boxMirrorConfigs)
                |zsze $ %{} :Expr (:at 1699464534081) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736960993648) (:by |rJG4IHzWf) (:text "|\"../src/apps/rhombic-mirror.mts")
                    |a $ %{} :Leaf (:at 1714755628974) (:by |rJG4IHzWf) (:text |:refer)
                    |g $ %{} :Expr (:at 1714755629826) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1731209247779) (:by |rJG4IHzWf) (:text |rhombicMirrorConfigs)
                |zt $ %{} :Expr (:at 1709657313552) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1736960997397) (:by |rJG4IHzWf) (:text "|\"../src/global.mts")
                    |b $ %{} :Leaf (:at 1709657320182) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1709657320531) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1713002174614) (:by |rJG4IHzWf) (:text |atomSolubleTree)
                |zu $ %{} :Expr (:at 1744516110784) (:by |rJG4IHzWf)
                  :data $ {}
                    |T $ %{} :Leaf (:at 1744516110784) (:by |rJG4IHzWf) (:text |app.img-counter)
                    |b $ %{} :Leaf (:at 1744516110784) (:by |rJG4IHzWf) (:text |:refer)
                    |h $ %{} :Expr (:at 1744516110784) (:by |rJG4IHzWf)
                      :data $ {}
                        |T $ %{} :Leaf (:at 1744516110784) (:by |rJG4IHzWf) (:text |img-slot!)
    |app.schema $ %{} :FileEntry
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |def)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |store)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |{})
                  |b $ %{} :Expr (:at 1699463594608) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1699463595486) (:by |rJG4IHzWf) (:text |:tab)
                      |b $ %{} :Expr (:at 1711260026046) (:by |rJG4IHzWf)
                        :data $ {}
                          |D $ %{} :Leaf (:at 1711260028146) (:by |rJG4IHzWf) (:text |turn-tag)
                          |T $ %{} :Expr (:at 1711260014386) (:by |rJG4IHzWf)
                            :data $ {}
                              |D $ %{} :Leaf (:at 1711260016101) (:by |rJG4IHzWf) (:text |get-env)
                              |L $ %{} :Leaf (:at 1711260020594) (:by |rJG4IHzWf) (:text "|\"tab")
                              |T $ %{} :Leaf (:at 1731211750626) (:by |rJG4IHzWf) (:text "|\"rhombic-mirror")
                  |j $ %{} :Expr (:at 1499755354983) (:by nil)
                    :data $ {}
                      |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |:states)
                      |j $ %{} :Expr (:at 1499755354983) (:by nil)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |{})
                          |j $ %{} :Expr (:at 1584781004285) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1584781007054) (:by |rJG4IHzWf) (:text |:cursor)
                              |j $ %{} :Expr (:at 1584781007287) (:by |rJG4IHzWf)
                                :data $ {}
                                  |T $ %{} :Leaf (:at 1584781007486) (:by |rJG4IHzWf) (:text |[])
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1499755354983) (:by nil)
          :data $ {}
            |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |ns)
            |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |app.schema)
    |app.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |)
          :code $ %{} :Expr (:at 1499755354983) (:by nil)
            :data $ {}
              |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |defn)
              |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |updater)
              |r $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |store)
                  |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |op)
                  |v $ %{} :Leaf (:at 1519489491135) (:by |root) (:text |op-id)
                  |x $ %{} :Leaf (:at 1519489492110) (:by |root) (:text |op-time)
              |v $ %{} :Expr (:at 1499755354983) (:by nil)
                :data $ {}
                  |T $ %{} :Leaf (:at 1688397777636) (:by |rJG4IHzWf) (:text |tag-match)
                  |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |op)
                  |n $ %{} :Expr (:at 1507399852251) (:by |root)
                    :data $ {}
                      |T $ %{} :Expr (:at 1688397783265) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1507399855618) (:by |root) (:text |:states)
                          |b $ %{} :Leaf (:at 1688397785768) (:by |rJG4IHzWf) (:text |cursor)
                          |h $ %{} :Leaf (:at 1688397786090) (:by |rJG4IHzWf) (:text |s)
                      |j $ %{} :Expr (:at 1584874625235) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1584874626558) (:by |rJG4IHzWf) (:text |update-states)
                          |j $ %{} :Leaf (:at 1584874628374) (:by |rJG4IHzWf) (:text |store)
                          |r $ %{} :Leaf (:at 1688397788043) (:by |rJG4IHzWf) (:text |cursor)
                          |t $ %{} :Leaf (:at 1688397788324) (:by |rJG4IHzWf) (:text |s)
                  |q $ %{} :Expr (:at 1699463582308) (:by |rJG4IHzWf)
                    :data $ {}
                      |T $ %{} :Expr (:at 1699463584779) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463585513) (:by |rJG4IHzWf) (:text |:tab)
                          |b $ %{} :Leaf (:at 1699463586886) (:by |rJG4IHzWf) (:text |t)
                          |h $ %{} :Leaf (:at 1710871354731) (:by |rJG4IHzWf) (:text |theme)
                      |b $ %{} :Expr (:at 1699463587805) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1699463588700) (:by |rJG4IHzWf) (:text |assoc)
                          |b $ %{} :Leaf (:at 1699463590146) (:by |rJG4IHzWf) (:text |store)
                          |h $ %{} :Leaf (:at 1699463590980) (:by |rJG4IHzWf) (:text |:tab)
                          |l $ %{} :Leaf (:at 1699463591790) (:by |rJG4IHzWf) (:text |t)
                  |t $ %{} :Expr (:at 1518157547521) (:by |root)
                    :data $ {}
                      |T $ %{} :Expr (:at 1688397789504) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1518157657108) (:by |root) (:text |:hydrate-storage)
                          |b $ %{} :Leaf (:at 1688397790936) (:by |rJG4IHzWf) (:text |data)
                      |j $ %{} :Leaf (:at 1584874637339) (:by |rJG4IHzWf) (:text |data)
                  |u $ %{} :Expr (:at 1688397780767) (:by |rJG4IHzWf)
                    :data $ {}
                      |D $ %{} :Leaf (:at 1688397781225) (:by |rJG4IHzWf) (:text |_)
                      |T $ %{} :Expr (:at 1688397780408) (:by |rJG4IHzWf)
                        :data $ {}
                          |T $ %{} :Leaf (:at 1688397780408) (:by |rJG4IHzWf) (:text |do)
                          |b $ %{} :Expr (:at 1688397780408) (:by |rJG4IHzWf)
                            :data $ {}
                              |T $ %{} :Leaf (:at 1695659902074) (:by |rJG4IHzWf) (:text |eprintln)
                              |b $ %{} :Leaf (:at 1688397780408) (:by |rJG4IHzWf) (:text "|\"unknown op:")
                              |h $ %{} :Leaf (:at 1688397780408) (:by |rJG4IHzWf) (:text |op)
                          |h $ %{} :Leaf (:at 1688397780408) (:by |rJG4IHzWf) (:text |store)
      :ns $ %{} :CodeEntry (:doc |)
        :code $ %{} :Expr (:at 1499755354983) (:by nil)
          :data $ {}
            |T $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |ns)
            |j $ %{} :Leaf (:at 1499755354983) (:by |root) (:text |app.updater)
            |r $ %{} :Expr (:at 1584874614885) (:by |rJG4IHzWf)
              :data $ {}
                |T $ %{} :Leaf (:at 1584874616480) (:by |rJG4IHzWf) (:text |:require)
                |j $ %{} :Expr (:at 1584874616720) (:by |rJG4IHzWf)
                  :data $ {}
                    |j $ %{} :Leaf (:at 1584874620034) (:by |rJG4IHzWf) (:text |respo.cursor)
                    |r $ %{} :Leaf (:at 1584874621356) (:by |rJG4IHzWf) (:text |:refer)
                    |v $ %{} :Expr (:at 1584874621524) (:by |rJG4IHzWf)
                      :data $ {}
                        |j $ %{} :Leaf (:at 1584874623096) (:by |rJG4IHzWf) (:text |update-states)
  :users $ {}
    |rJG4IHzWf $ {} (:avatar nil) (:id |rJG4IHzWf) (:name |chen) (:nickname |chen) (:password |d41d8cd98f00b204e9800998ecf8427e) (:theme :star-trail)
    |root $ {} (:avatar nil) (:id |root) (:name |root) (:nickname |root) (:password |d41d8cd98f00b204e9800998ecf8427e) (:theme :star-trail)
