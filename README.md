# The Curse of The Pharaoh
This project is a MUD (multi-user dungeon) built using Racket,  a multi-paradigm programming language based on the Scheme dialect of Lisp. This was made in homage to the old MUD games, as a fun way to learn functional programming.

## Documentation:

### Variables of the game:
- Marco's money: 

```(define gold 10)```
- Marco's items, frequently changes within the game.

```(define inventory (append (list gold) '(food water clothes rope)))```
- Marco's armor

```(define armor 0)```
- Marco's wounds

```(define wounds 0)```
- Marco's actual status, it's possible to change. 

```(define status (append '(CURSED Healthy  no-weapon freeman) (list armor)))```
- Marco's situation, used as paramater to what you can do at the moment

```(define situation 0)```
- Marco's food and water quantity.

```(define food 1)(define water 2)```
- Regions(0:City in the center, 1:City at North, 2: City at South, 3: City at East, 4:City at West):

```(define actual-place 0)```

### Cheats:
- Money Cheat: motherlore

```(define (motherlore)(set! inventory (remove gold inventory))(set! gold (+ 100 gold))(set! inventory (append (list gold) inventory)))```

- Food Cheat: imfat

```(define (imfat)(set! inventory (append (list 'food) inventory))(set! food (+ food 10)))```

- Total wisdom: athena

```(define (athena) actions inventory status actual-place)```

### Functions:

- Member?: Check if something is a member of a list.

```(define member?(lambda (a lat)(cond[(null? lat) #f][(eq? (car lat) a) #t][#t (member? a (cdr lat))])))```

- remove-from-inventory: Remove something from Marco's inventory.

```(define remove-from-inventory(lambda (a)(cond[(null? inventory) (quote())][#t (set! inventory (remove a inventory))])))```

- add-to-inventory: Add something to Marco's inventory.

```(define add-to-inventory(lambda (a)(set! inventory (append (list a) inventory))))```

- change-situation: Alters the point of the game you are.

```(define (change-situation n)(set! situation n))```

- change-direction: Change Marco's direction when traveling.


```(define (change-direction n)(if (and (> food 0) (member? 'freeman status))```

```(begin(remove-from-inventory  'food)(set! food (- food 1))```

```(cond [(= n 1) (travel-north)]```

```[(= n 2) (travel-south)]```

```[(= n 3) (travel-east)]```

```[(= n 4) (travel-west)]```

```[(= n 5) (the-minor-quest)]```

```[(= n 6) (the-major-quest)]```

```[#t (set! actual-place 5)]))(printf "Not enough food to travel")))```
              
              
- take-hit: When a enemy attack you, you either lose armor points or die if you have no armor.

```(define (take-hit n)(if(eq? armor 0)(begin(set! armor (- armor n))(set! wounds (+ wounds n))(printf "You felt your armor saved your life this time,but you're wounded...maybe it's time to flee"))```
```(begin (change-situation 0)(printf "This blow was fatal. You're dead. GAME OVER\n\n\n\n")(menu))))```

- debt: This function debts the item price from your gold, and add the specified item in your inventory.If Marco have not enough money, the player is warned.

```(define (debt a b)(if(>= gold a)(begin(set! inventory(remove gold inventory))(set! gold (- gold a))(add-to-inventory b)(set! inventory (append (list gold) inventory))(append '(**** You got)(list b '****)))```
```(printf "You can't afford it, man...")))```

- weapon?: This function checks if Marco has a weapon.

```(define (weapon?)(if (or (member? 'Iron_Sword inventory)(member? 'Scimitar inventory)(member? 'Saber inventory)(member? 'Silver_Sword inventory)(member? 'Silver_Bow inventory)(member? 'Steel_Bow inventory)(member? 'Iron_Bow inventory))```
```(#t)(begin(set! status (append status '(no-weapon)))#f)))```

- heal: This functions heal your wounds and restore 1 armor point.Only Hellenist people taught by monks can heal through faith.

```(define (heal)(if (and(member? 'Hellenist status)(> wounds 0))(begin(set! armor (+ armor 1))(set! wounds 0)(printf "You felt the power of the great God Asclepius in your veins, healing your wounds"))```
```(printf "You can't healself over this point! (Maybe you don't know how yet)")))``` 


- actions: Show actions

```(define actions '(accept attack bargain buy change climb deny drink eat escape explore feed fight flee go instructions ignore insert leave jump nap open organize pay play pull put push read reflect run scare shoot sleep start steal throw travel visit wake))```

- directions: Show directions

```(define directions '(north south east west))```

- credits: Show credits

```(define (credits)(printf "You did! The cup is yours, the Holy Grail! You drunk water with it and you're not cursed anymore......```
```----<> Congratulations, you saved yourself from the Curse of the Pharaoh <>----```

```<> Programmer/Developer: Hygor L. B. Marques```
  
- start: Start Menu

```(define start (display "                   -------------------- The Curse of the Pharaoh---------------\n Write '(Begin)' to start or '(Instructions)' to learn how to play:"))```

## Screenshot:

![alt text](https://i.imgur.com/OZ2w3aV.png)
