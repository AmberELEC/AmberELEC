memberDialogs = [ "I have nothing to say!" ] * 20
memberAnswer = [ "Ok" ] * 20

# Oracle talk - level 1
memberDialogs[1] = "Hello, Commander!\n" + \
              "It's been ages\n" + \
              "since we've last met.\n" + \
              "You never visit...\n"

# Answer for the oracle member  - level 1
memberAnswer[1] = "\n" + \
              "You're looking hale\n" + \
              "and hearty, lil' buddy!\n"



# Oracle talk - level 3
memberDialogs[3] = "Keen! Here's still\n" + \
              "lots of work to do!\n" + \
              "If you come across\n" + \
              "the Janitor, tell him\n" + \
              "to head over!\n"

# Answer for the oracle member  - level 3
memberAnswer[3] = "Have you ever tried\n" + \
              "sticking your left hand\n" + \
              "into your right pocket?\n"


# Oracle talk - level 4
memberDialogs[4] = "1 cucumber sliced\n" + \
              "1 medium onion chopped\n" + \
              "1 teaspoon mustard seed\n" + \
              "a pinch of salt\n" + \
              "...\n"

# Answer for the oracle member  - level 4
memberAnswer[4] = "I have this sudden\n" + \
              "craving for an\n" + \
              "umbrella drink.\n"

# Oracle talk - level 5
memberDialogs[5] = "What a nice\n" + \
              "little castle moat,\n" + \
              "don't you think?\n" + \
              "Once again the Janitor\n" + \
              "outdid himself!\n"

# Answer for the oracle member  - level 5
memberAnswer[5] = "Sure,\n" + \
              "can I borrow\n" + \
              "your cape?\n"



# Oracle talk - level 6
memberDialogs[6] = "Keen! Here's still\n" + \
              "lots of work to do!\n" + \
              "If you come across\n" + \
              "the Janitor, tell him\n" + \
              "to head over!\n"

# Answer for the oracle member  - level 6
memberAnswer[6] = "\n" + \
              "...don't play it again,\n" + \
              "Sam.\n"


# Oracle talk - level 8
memberDialogs[8] = "\n" + \
              "... somehow\n" + \
              "I must have lost\n" + \
              "the construction plans.\n"

# Answer for the oracle member  - level 8
memberAnswer[8] = "It's things like this\n" + \
              "that make me wish\n" + \
              "I were Canadian\n" + \
              "...\n"


# Oracle talk - level 10
memberDialogs[10] = "\n" + \
              "Oh for God's sake!\n" + \
              "How did I get up here?\n"

# Answer for the oracle member  - level 10
memberAnswer[10] = "\n" + \
              "Out of toilet paper?\n"


# Oracle talk - level 11
memberDialogs[11] = "I'm thinking\n" + \
              "of a number\n" + \
              "between one and ten\n" + \
              "and I don't know why.\n"

# Answer for the oracle member  - level 11
memberAnswer[11] = "\n" + \
              "Me too!\n"



# Getters for the interface
def getMemberDialog(level):
        msg = memberDialogs[level]
        return msg

def getMemberAnswer(level):
       return memberAnswer[level]

