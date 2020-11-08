def getLevelText(level):   
       if level == 5:
          text =  "Princess Lindsey says:\n"
          text += "You won't be able to \n"
          text += "defeat Mortimer with\n"
          text += "your stunner alone!"
       elif level == 11:
          text =  "Lt. Barker says:\n"
          text += "Beware of the\n"
          text += "Krodacian Overlords!"
       elif level == 2:
          text =  "Spot says:\n"
          text += "The Shikadi are\n"
          text += "invincible while\n"
          text += "climbing poles!" 
       elif level == 15:
          text =  ""
       else:
          text =  "Oracle Janitor says:\n"
          text += "There's something\n"
          text += "mysterious beneath the\n"
          text += "giant crater."
       return text

def getLevelTextBmp(level):   
       if level == 5:
          bmpIdx = 40
       elif level == 11:
          bmpIdx = 38
       elif level == 2:
          bmpIdx = 41
       else:
          bmpIdx = 39
       return bmpIdx


