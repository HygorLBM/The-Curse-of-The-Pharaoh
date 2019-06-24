#lang racket

(provide (all-defined-out))

;----------------------------------
;    Variables of the game
;----------------------------------
;Marco's money
(define gold 10)
;Marco's items, frequently changes within the game.
(define inventory (append (list gold) '(food water clothes rope)))
;Marco's armor
(define armor 0)
;Marco's wounds
(define wounds 0)
;Marco's actual status, it's possible to change. 
(define status (append '(CURSED Healthy  no-weapon freeman) (list armor)))
;Marco's situation, used as paramater to what you can do at the moment
(define situation 0)
;Marco's food and water quantity.
(define food 1)
(define water 2)
;Variable who defines where you are:
;0:City in the center, 1:City at North, 2: City at South, 3: City at East, 4:City at West.
(define actual-place 0)

;---------------------------------
;      Game cheats
;----------------------------------
;Money Cheat
(define (motherlore)
  (set! inventory (remove gold inventory))
  (set! gold (+ 100 gold))
  (set! inventory (append (list gold) inventory)))

;Food Cheat
(define (imfat)
  (set! inventory (append (list 'food) inventory))
  (set! food (+ food 10)))

;Total wisdom
(define (athena)
  actions
  inventory
  status
  actual-place)


;-----------------------
;     Functions
;-----------------------
  
;This function was designed in the Assignment 1 and help us now.
;This allows us to check if something is a member of a list. It's important to check if the character have a item in his inventory, as food (he needs to travel).
(define member?
  (lambda (a lat)
  (cond
    [(null? lat) #f]
    [(eq? (car lat) a) #t]
    [#t (member? a (cdr lat))])))

;Used rember as a example to wrote this.
(define remove-from-inventory
  (lambda (a)
    (cond
      [(null? inventory) (quote())]
      [#t (set! inventory (remove a inventory))])))

;Add something to inventory.
(define add-to-inventory
         (lambda (a)
  (set! inventory (append (list a) inventory))))

;Change the point of the game you are.
(define (change-situation n)
  (set! situation n)
 )

;Change the direction if Marco travels.
(define (change-direction n)
      (if (and (> food 0) (member? 'freeman status))
       (begin(remove-from-inventory  'food)(set! food (- food 1))       
         (cond
           
              [(= n 1) (travel-north)]
              [(= n 2) (travel-south)]
              [(= n 3) (travel-east)]
              [(= n 4) (travel-west)]
              [(= n 5) (the-minor-quest)]
              [(= n 6) (the-major-quest)]
              [#t (set! actual-place 5)]))

       (printf "Not enough food to travel"))
              )

; When a enemy attack you, you lose armor points or die if you have no armor.
(define (take-hit n)
  (if(eq? armor 0)
    (begin(set! armor (- armor n))(set! wounds (+ wounds n))(printf "You felt your armor saved your life this time,but you're wounded...maybe it's time to flee"))  
    (begin (change-situation 0)(printf "This blow was fatal. You're dead. GAME OVER\n\n\n\n")(menu))))



;This function was created to refacture the old giant "buy" action.
;This function debt the item price in your gold, and add the item in your inventory.
;If Marco have not enough money, the player is warned.
(define (debt a b)
  (if(>= gold a)
     (begin(set! inventory(remove gold inventory))(set! gold (- gold a))(add-to-inventory b)(set! inventory (append (list gold) inventory))(append '(**** You got)(list b '****)))
     (printf "You can't afford it man...")
  ))


;This function checks if Marco has a weapon.
(define (weapon?)
   (if (or (member? 'Iron_Sword inventory)(member? 'Scimitar inventory)(member? 'Saber inventory)(member? 'Silver_Sword inventory)
           (member? 'Silver_Bow inventory)(member? 'Steel_Bow inventory)(member? 'Iron_Bow inventory))
       (#t)
       (begin(set! status (append status '(no-weapon)))#f)
   )
)


;This functions heal your wounds and restore 1 armor point.
;Only Hellenist people taught by monks can heal through faith.
(define (heal)
  (if (and(member? 'Hellenist status)(> wounds 0))
      (begin(set! armor (+ armor 1))(set! wounds 0)(printf "You felt the power of the great God Asclepius in your veins, healing your wounds"))
      (printf "You can't healself over this point! (Maybe you don't know how yet)"))) 



(define actions '(accept attack bargain buy change climb deny drink eat escape explore feed fight flee 
                  go instructions ignore insert leave jump nap open organize pay play pull put push read reflect run
                  scare shoot sleep start steal throw travel visit wake))


(define directions '(north south east west))


(define (credits)
  (printf "You did! The cup is yours, the Holy Grail! You drunk water with it and you're not cursed anymore......
           ----<> Congratulations, you saved yourself from the Curse of the Pharaoh <>----
         <> Programmer/Developer: Hygor L. B. Marques
  
(define start
  (display "                   -------------------- The Curse of the Pharaoh---------------\n Write '(Begin)' to start or '(Instructions)' to learn how to play:"))

(define (menu)
  (printf "                   -------------------- The Curse of the Pharaoh---------------\n Write '(Begin)' to start or '(Instructions)' to learn how to play:"))



;-------------------------
;        Actions
;-------------------------

(define (Begin)
  (cond[(< situation 1) (printf "You're Marco, a adventurer who lost everything in your last journey.
You had entered in a pyramid, searching a legendary treasure, and was surprised with many battles within.
Your bow was out of arrows, your sword broke, your desperation was fulling each corner of that damned place.
In a act of pure despair, you ran into a room that shined a purple light.
There you were marked with the Curse of the Pharaoh.
This curse happened a month ago. Now, you have two weeks to heal yourself, or die trying.
In your last two weeks you searched for someone who could help you.
Yesterday you met a man who said someone who drinks water from the Holy Grail is cured from any evil.
Everything you own is some food, some water, some clothes, a rope, and 10 pieces of gold.
You woke up in the inn, what's your next move, adventurer ?\n")]
                     [(printf " The game is already running!" )])
   (change-situation 1))


(define (Instructions)
  (printf "                 How to play 'The Curse of the Pharaoh' ?
This is a MUD game. Everything you need to play is write what you want to do next, and hope you acquire sucess in your move.
Your movement must always start with a ACTION.But the game don't know each possible action of the world.

Together with the ACTION, you should try to combine with objects, directions, names(people), ...
Here are some examples of moves that are possible somewhere in this game:(go 'north)|(attack 'Iron_Sword)|(visit 'inn)
Have fun exploring all the possibilites.
Don't forget the basics of the game: (ACTION 'object|direction|person...).
Write (Begin) to start.

[TIP: (go 'north) looks like the perfect starting action, adventurer!]"))


;To travel
;This game works with locations at each city. You must >visit< a place in the cities to go for another "rooms"
;So this are the main places you can go, but there are much more rooms.
(define (go x)
    (if (eq? situation 0) (printf "Perhaps you should >Begin< the game!")
        (begin(if (null? x)
         (cond   [(= 1 situation)(printf "Where?")]
                 [(printf "") ])
    (cond [(eq? x 'north) (change-direction 1)]
          [(eq? x 'south) (change-direction 2)]
          [(eq? x 'east) (change-direction 3)]
          [(eq? x 'west) (change-direction 4)]
          [(eq? x 'desert) (change-direction 5)]
          [(eq? x 'Cybele) (change-direction 6)]
          [(printf "Don't know this direction")])))))

;To visit somewhere in a location
(define (visit x)
  (cond  [(eq? actual-place 1)
               (begin (cond [(eq? x 'armorer)      (visit-blacksmith)]
                            [(eq? x 'blacksmith)   (visit-blacksmith)]
                            [(eq? x 'bowyer)       (visit-bowyer)]
                            [(eq? x 'market)       (visit-marketer)]
                            [(eq? x 'seller)       (visit-marketer)]
                            [(eq? x 'church)       (visit-church)]
                            [(eq? x 'tavern)       (visit-inn)]
                            [(eq? x 'inn)          (visit-inn)]
                            [#t (printf "You can't find this here")]))]
         [(eq? actual-place 2)
             (begin (cond   [(eq? x 'armorer)      (visit-blacksmith)]
                            [(eq? x 'blacksmith)   (visit-blacksmith)]
                            [(eq? x 'swordsmith)   (visit-swordsmith)]
                            [(eq? x 'market)       (visit-marketer)]
                            [(eq? x 'seller)       (visit-marketer)]
                            [(eq? x 'church)       (visit-church)]
                            [(eq? x 'theater)      (visit-theatre)]
                            [(eq? x 'theatre)      (visit-theatre)]
                            [(eq? x 'inn)          (visit-inn)]
                            [#t (printf "You can't find this here")]))]
         [(eq? actual-place 3)
           (begin (cond     [(eq? x 'armorer)      (visit-blacksmith)]
                            [(eq? x 'blacksmith)   (visit-blacksmith)]
                            [(eq? x 'shieldsmith)  (visit-shieldsmith)]
                            [(eq? x 'market)       (visit-marketer)]
                            [(eq? x 'seller)       (visit-marketer)]
                            [(eq? x 'church)       (visit-church)]
                            [(eq? x 'temple)       (visit-church)]
                            [(eq? x 'tavern)       (visit-inn)]  
                            [(eq? x 'inn)          (visit-inn)]
                            [#t (printf "You can't find this here")]))]
         [(eq? actual-place 4)
           (begin (cond     [(eq? x 'armorer)      (visit-armorsmith)]
                            [(eq? x 'blacksmith)   (visit-blacksmith)]
                            [(eq? x 'market)       (visit-marketer)]
                            [(eq? x 'seller)       (visit-marketer)]
                            [(eq? x 'library)      (visit-library)]
                            [(eq? x 'tavern)       (visit-inn)]  
                            [#t (printf "You can't find this here")]))]
               
             
           

         
         [#t (printf "You can't find this location here")]
         ))

;This function is quite big, but I can't see why to refacture.
;The function is the same for any seller:
;-> Check what item was purchased and if there is enough gold to buy.
;->If so, remove as much gold needed and add the item in the inventory.
;->If not, warns the player that he does not have enough gold.
(define (buy x)
  (cond
    ;Blacksmith
    ;1:Iron_Armor (5 gold), 2: Iron_Sword (5 gold), 3: Iron_Bow (5 gold), 4: Iron_Shield (5 gold).
    [(eq? situation 11)(begin(set! status (remove 'no-weapon status))(cond
                              [(eq? x 1)(debt 5 'Iron_Armor)]
                              [(eq? x 2)(debt 5 'Iron_Sword)]
                              [(eq? x 3)(debt 5 'Iron_Bow)]
                              [(eq? x 4)(debt 5 'Iron_Shield)]))]
   
    ;Marketer
   ;1:Map (3 gold), 2: Meat (2 gold each), 3: Pretty-clothes (15 gold), 4: Cantel with water (2 gold).
   [(eq? situation 12) (begin(cond
                              [(eq? x 1)(debt 3 'Map)]
                              [(eq? x 2)(begin(set! food (+ 1 food))(debt 2 'food))]
                              [(eq? x 3)(debt 15 'Pretty_clothes)]
                              [(eq? x 4)(begin(set! water (+ 1 water))(debt 2 'water))]))]

   ;Inn
   [(eq? situation 14)]

   ;Bowyer
    ; 1: Silver_Bow(20 gold), 2: Steel_Bow (10 gold), 3: Iron_Bow(5 gold) 
   [(eq? situation 15)(begin(set! status (remove 'no-weapon status))(cond
                              [(eq? x 1)(debt 20 'Silver_Bow)]
                              [(eq? x 2)(debt 10 'Steel_Bow)]
                              [(eq? x 3)(debt 5 'Iron_Bow)]))]
   
   
    ;Swordsmith
    ;1: Silver_Sword (20 gold), 2: Saber (10 gold), 3: Scimitar (7 gold), 4: Iron_Sword (5 gold) 
   [(eq? situation 16)(begin(set! status (remove 'no-weapon status))(cond
                              [(eq? x 1)(debt 20 'Silver_Sword)]
                              [(eq? x 2)(debt 10 'Saber)]
                              [(eq? x 3)(debt 7 'Scimitar)]
                              [(eq? x 4)(debt 5 'Iron_Sword)]))]
   
                         
    ;Shieldsmith
   ;1: Hyllian_Shield (1000 gold), 2: Steel_Shield (10 gold), 3: Iron_Shield (5 gold), 4: Wood_Shield (3 gold) 
   [(eq? situation 17)(begin(cond
                              [(eq? x 1)(debt 1000 'Hyllian_Shield)]
                              [(eq? x 2)(debt 10 'Steel_Shield)]
                              [(eq? x 3)(debt 5 'Iron_Shield)]
                              [(eq? x 4)(debt 3 'Wood_Shield)]))]

   
    ;Armorsmith
   ;1: Mithril (500 gold), 2: Iron_Armor (20 gold), 3: Leather_Armor (5 gold)
   [(eq? situation 18)(begin(cond
                              [(eq? x 1)(begin(set! armor (+ 10 armor))(debt 500 'Mithril))]
                              [(eq? x 2)(begin(set! armor (+ 3 armor))(debt 20 'Iron_Armor))]
                              [(eq? x 3)(begin(set! armor (+ 1 armor))(debt 5 'Leather_Armor))]))]                            
    )
  )

;This action was built to be used in the library
;The library is where the player discover about the game\background  and some options to follow.
(define (study x)
(if(eq? situation 20)
  (begin(cond

    [(eq? x 1) (printf "The book tells the story of two magicians, Gankart and Dumborbore.
Gankart lived his life by removing dangerous treasures of the hand of mankind, while Dumborbore lived his life by destroying the Horcruxes a powerful wizard of darkness.
Dumborbore was sent by the church to confront Gankart because he was preventing cross trying to rescue the Holy Grail, which is in possession of Gankart (as many treasures).
When Dumborbore discovered the powers of the Holy Grail he joined Gankart protect the cup. It is said that only a good armor can withstand a magic made by the two magicians.
The book also said that the only way to access the item would fool any of the wizards, as >> (tell that the Holy Grail is a Horcrux) << ")]


    [(eq? x 2)(printf "The book tells the dangers and myths about Cybele's Temple.
According to what the book says, the place is guarded by strange creatures so many return testifying that they could not proceed.
The book also says that injured people in the temple almost never survive, saying it is a good idea to get to the place with some armor, or prevent any blow there.
In addition to well-equipped, the book says that when it comes to the center of the temple violence is not the way to achieve the greatest secrets that the place hides....")] 

    [(eq? x 3)(printf "The book gave several outlandish ideas to earn some money in the kingdom.
Among these absurd hypotheses was a solution that you found reliable:
Many men are surprised by the moving lake of quicksand thatpassing through the desert.
It is very common for family members and other people desperate to hire someone to save the lost.
The site more desperate resort loved them to find people willing to this adventure are tavers and inns")]
    [#t (printf "You can't find nothing about this subject here")]
    
    ))
 (printf "You can't find books to study this here.")))


;This action is used to learn stuff at the Temple.
(define (learn x)
  (begin(set! status (append status '(Hellenist)))
  (cond [(eq? x 'healing)(printf "
The monk introduced you to Hellenistic faith, especially the worship of the god Asclepius, the Greek god of healing.
You made vows to be a Hellenist now, and learned how> heal <yourself." )]
        [#t (printf "It's not possible to learn this right now?")]
 )))


;This function is by the player to accept the minor-quest, where he wins the money that he needs.
(define (accept)
  (begin(printf "The man smiled at you, taking 20 gold pieces from his pocket and handing you. I will give you my last 20 gold pieces if you bring my son here.
He then asked the man the tavern bring some food for you to take.
-> My son is in the desert, please go save him.")(set! food (+ 2 food))(set! inventory (append '(food food) inventory))(set! inventory (remove gold inventory))(set! gold (+ 20 gold))(set! inventory (append (list gold) inventory))))


;This action is used to throw the rope and save the boy at the minor-quest.
;If the player tries to throw something else, he loses the item.
;If he tries to thow something he doesn't have in the inventory, it warns the player.
;If the players uses this action in a random place it returns "...Why?"!
(define (throw x)
  (if(eq? situation 14)(begin (if(eq? x 'rope)(begin(change-situation 70)(printf "The boy was almost dead when you give him a last hope... in this case, rope.
You pushed him from the depths of the quicksand, and he felt amazing when you said his father send you to save him.
He asked for you take him to meet his father."))
                                 (begin(if(member? x inventory)(begin(remove-from-inventory x)(printf "This was not a good idea"))(printf "You don't own this")))))
  (printf "... Why ?")))


;The function to attack
(define (attack x)
  (cond [(eq? situation 91) (attack-zombie x) ]
        [#t (printf "What are you attacking  ?")]))


;This action can be used to flee from the dangers of the Cybele temple
(define (flee)
  (if (eq? actual-place 5)
      (change-direction 1)
      (printf "...Are you okay ?")
  )
)

(define (explore)
  (begin(printf "A tavern is the best place to a adventurer explore! \n")(visit-inn)))

;The action to drop something, is usefull in the major-quest
(define (drop x)
  (if (member? x inventory)
      (begin(set! inventory (remove x inventory))
             (if(eq? situation 92)
                (begin(if (weapon?)
                  (begin(set! status (append status '(no-weapon)))(printf "The basket began to shine but then all glow disappeared as a creature waiting for more food."))
                  (begin(change-situation 93)(printf "All their weapons were involved in the light that shone in the basket ... and disappeared.")(major-quest-boss))
               ))(printf "")))    
      (printf "You can't drop what you don't have!")
  )  
)



(define (deceive)
  (if(eq? situation 93)
     (begin(printf "You said that the Holy Grail is actualy a horcrux.
Dumborbore heard what you said and looked confused for Gankart.
The magician with staff said to not give ear to this nonsense, but Dumborbore felt so cheated... How Gandart could hide this truth about the Grail?\n**************")(THE-FINAL-ESCAPADE))
           (printf "... What? Who ? When ?"))
)

;The sentence the book from the west library sugested for you to deceive the wizards
(define (tell that the Holy Grail is a Horcrux)
 (deceive))

;Another way to deceive the wizards
(define (Holy Grail is a Horcrux)
 (deceive))

;This action, as the name implies, is for jumping.
;Jumping is not that usefull at most game, but is the final action you must perform to win!
(define (jump)
  (if (eq? situation 100)
      (begin(credits)(menu))
      (printf "You jumped... YAY!"))
)


;--------------------
;       Cities
;--------------------

;Travel to the city at North
(define (travel-north)
  (begin(set! actual-place 1)
        (printf "You're in the North city!You heard that this city is famous for producing excellent arches, good taverns, and be close to the temple of Cybele, but you have no supplies to travel further north.

TIP: It might be a good time to> visit <some place in the city, or random> explore <. ")))

;Travel to the city at South
(define (travel-south)
  (begin(set! actual-place 2)
        (printf "You're in a city at South. This city is the right place to buy swords. You can also watch the famous play 'The Tale of the 2 Wizards' here.
 
TIP: It might be a good time to> visit <some place in the city, or random> explore <. ")))


;Travel to the city at East
(define (travel-east)
  (begin(set! actual-place 3)
        (printf "You're in the East city. The city is full of guards. Most of them are close to church, watching a beautiful shield that a seller displays as his best product.
 
TIP: It might be a good time to> visit <some place in the city, or random> explore <. ")))


;Travel to the city at West
(define (travel-west)
  (begin(set! actual-place 4)
        (printf "This city is considered pagan, does not live in the protection of the church, and has a large library in the center, instead of a church or temple.
 
TIP: It might be a good time to> visit <some place in the city, or random> explore <. ")))



;-------------------------------
;           Places
;-------------------------------
; These are places Marco can visit in town (with the action >visit< )

;The blacksmith sells all type of weapons + shield, but commom.  
(define (visit-blacksmith)
  (if (< actual-place 5)
    (begin (change-situation 11)(printf "Welcome. If you want the commom and good stuff, you're talking with the right man.
      1:Iron_Armor (5 gold), 2: Iron_Sword (5 gold), 3: Iron_Bow (5 gold),4: Iron_Shield (5 gold).
      ->To buy something write: > buy 'number <"))
    (printf "There's no blacksmith here to visit")))

;The marketer sells items not used for battle.
(define (visit-marketer)
  (if (< actual-place 5)
    (begin (change-situation 12)(printf "Hello. Here we don't sell any war items. If you want swords or shields, talk to the Blacksmith.
                                         But if you want something really usefull, take a look!
      1:Map (3 gold), 2: Meat (2 gold each), 3: Pretty-clothes (15 gold), 4: Cantel with water (2 gold).
      ->To buy something write: > buy 'number <"))
     (printf "There's no blacksmith here to visit")))

;The church is different at each place.
(define (visit-church)
  (change-situation 13)
  (cond
  [(eq? actual-place 1)(north_church)]
  [ (eq? actual-place 2)(south_church)]
  [ (eq? actual-place 3)(east_church)]
[#t (printf "There's no church around.")])) 

;The inn
(define (visit-inn)
  (if(eq? situation 70)(begin(printf "
-> Oh my god... thank you.The other half, as promised.
Tou took 20 pieces of gold and felt blessed") (set! inventory (remove gold inventory))(set! gold (+ 20 gold))(set! inventory (append (list gold) inventory)))
  (begin(change-situation 14)(printf "When you entered the tavern, you noticed a man who was crying in a humiliating manner on the counter. Seeing you enter the place, it was his direction and begged:
Please help me! My son, so young, was coming from the west and disappeared.
I'm pretty sure he's lost or even ... Swallowed in the quicksand.Could you try to rescue him, please? I'll buy you food and money.''
-> TIP: You can >accept< or ignore the proposal"))))


;The bowyer sells bows.
(define (visit-bowyer)
  (if(eq? actual-place 1)
  (begin(change-situation 15) (printf "Welcome to the Bobblo Bowyer. We have the best bows of the country to offer. Take a look at our products:
1: Silver_Bow (20 gold), 2: Steel_Bow (10 gold), 3: Iron_Bow (5 gold).
->To buy something write: >buy 'number <" ))
  (printf "There's no bowyer here to visit")
  ))

;The swordmith is specialized with swords.
(define (visit-swordsmith)
  (if(eq? actual-place 2)
  (begin(change-situation 16) (printf "Welcome to the Sabino Swordsmith. We have the best swords you can possibly find. Take a look at our products:
1: Silver_Sword (20 gold), 2: Saber (10 gold), 3: Scimitar (7 gold), 4: Iron_Sword (5 gold)  .
->To buy something write: >buy 'number <" ))
  (printf "There's no swordsmith here to visit")
  ))

;The shieldsmith sells shields...they maybe are usefull.
(define (visit-shieldsmith)
  (if(eq? actual-place 3)
  (begin(change-situation 17) (printf "Welcome to the Sence's Shieldsmith. There's nothing you can't defend against if you have the money,man. Take a look at our products:
1: Hyllian_Shield (1000 gold), 2:Steel_Shield  (10 gold), 3: Iron_Shield (5 gold), 4: Wood_Shield (3 gold)  .
->To buy something write: >buy 'number <" ))
  (printf "There's no shieldsmith here to visit")
  ))

;The armorsmith sells armors with different qualities.
(define (visit-armorsmith)
  (begin(change-situation 18) (printf "
Welcome to the Aerid's Armorsmith. Deads can't swing a sword! Take a look at our products:
          1: Mithril (50 gold), 2: Iron_Armor (20 gold), 3: Leather_Armor (5 gold).
->To buy something write: >buy 'number <" ))
  )

;The theatre tells about their interpretation about the 'Tale of the 2 Wizards'
(define (visit-theatre)
  (begin(change-situation 19) (printf "
You're with a lot of people watching a drama play. The play starts with a dancer, who (after some dance) is murdered by a dark wizard.
The soldiers try to catch the murderer, but fails. Another wizard character enters the play, performed by a inexperienced actor.
This character persecutes the dark wizard and in a strange battle, defeat him. The (good) wizard then surrenders herself to the church.
The good wizard dies smiling regretting his sins and hoping to find the dancer in the other side.
... What a bizarre story.")         
  ))

;This is the famous library.
;Here you can learn about interesting stuff from/for the game.
;This is only the  text informing you the books you can read, snd this don't have a reason to be refactored.
;The logic and content is displayed in the >study< function.
  (define (visit-library)
 (begin(change-situation 20)
 (printf "
You headed for the famous city library, lit and in contrast to the rest of the city, which seems so dangerous because of the lack of protection and customs of the church. You searched for topics that could help you find what you were looking for.
At the corner table where you are, you brought books on the following subjects:
     1: The Secret History of the two wizard brothers.
     2: The mysteries of the temple of Cybele
     3: How to get a few bucks traveling the kingdom of Albion.
->To read something write: (study 'number) ")))


;-----------------
;     Churches
;-----------------
(define (north_church)
  (printf "
You entered the church. Apparently this church was very busy, as well as crowded, a priest performed a Mass with the faithful. You received a receptive look of the priest and knelt to pray.
After a few prayers the priest told you how the city on the west refused to close the doors of their pagan library, which contained dangerous information and books with allegedly false information about the whereabouts of the Holy Grail (the treasure you seek) .He he said the church is deciding if those who seek knowledge in places like this should no longer receive the Christian grace.
You eat the communion wafer and drink the wine, and feel healthy."))

(define (south_church)
  (printf "
You entered the church.This does not seem to be a Christian church.
A monk of a religion that you don't know approaches and asks calmly:
You're here to >learn< the art of healing "))

(define (east_church)
  (printf "
You entered the temple, in the East City.A bishop came towards you and said that a special meeting is happening today. He said only the church clergy and nobles can participate.
He was not pleased that you got close enough to hear something discussed inside:
-> We send many troops to Cybele Temple, mages brothers wounded and frightened all who approached. But we will recover the Grail, rest assured.
But that was all you could find out today, as they drove you to the streets again.")
  )


;-------------**************------------------------
;-------------------------
;    Enemies
;-------------------------
(define (attack-zombie x)
  (if (member? x inventory)
      (begin(cond
              [(or (eq? x 'Iron_Sword )(eq? x 'Scimitar)(eq? x 'Saber)(eq? x 'Silver_Sword)) (begin(printf "You cutted of the head!Nice... move on\n*****\n")(change-situation 92)(major-quest-continues))]
              [#t (begin(printf "This was not that usefull to attack... omg
                         ")(take-hit 1))]))
     (begin(printf "You don't own this item to attack. The zombie attacked you!
                   ")(take-hit 1))
  ))

;--------------------------
;   The quests
;--------------------------

(define  (the-minor-quest)
  (if(eq? situation 14)(begin(printf "You was walking in the desert when realized that in some area ahead, the sand was moving. A moving quicksand lake in the desert?It's even possible?
In the middle of that astouning vision you saw some skeletons and a kid almost buried in the sand, with a arm pointed to the heavens.
As the quicksand lake moved closer,you jumped over a cactus. Yuck! That hurts... The boy is going with the sand...
What you're gonna do ?
TIP: Maybe you have something you can use to save him, take a look at your >inventory< "))(begin(printf"You walked in a desert.. you drank water but you still thirsty!")(change-direction 4))))

(define (the-major-quest)
  (change-situation 91)
  (printf "\nA monster with a body full of arrows is coming to you... maybe it's time to someone >attack< him with other stuff")
  )

(define (major-quest-continues) (printf "You found yourself in a big temple, the temple of Cybele.
A structure that looks like a basket is at the middle. It's possible to read: A wise man should >drop< all your weapons!"))

(define (major-quest-boss) (printf "The Holy Grail appeared in the light that shone in the corner of the room.
But as soon as the treasure appeared, also appeared two famous and seemingly powerful figures, Gankart and Dumborbore!
Gankart pointed his staff to you while Dumborbore vociferated 'Go away! Flee as we allow you to do'
Triumph over the two magicians seems impossible, what will you do? "))

(define (THE-FINAL-ESCAPADE) (begin(change-situation 100)(printf "As the two magicians began an epic clash that will most likely bring down the Cybele temple, you took the chance to catch the holy grail and run.
Upon leaving the temple you found yourself in a last challenge: The ground began to open in front of you.
****You Shall not pass ***** you heard the voice of Gankart back there.
The hole is not too large ... perhaps one simple action to end this journey forever.")))