PROG ?= + [ - - - - - - - > + + < ] > + + . + + + + + + + + + . - - - - - . - - - - - - - - - - - - . + + + + + + + . - .
MEM ?= . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 
PTR := .
PC := 
OUT_BUFFER :=

MAX := ................................................................................................................................................................................................................................................................
ALPHABET := ! A " \\\# $$ % & ' ( ) * + , - . / 0 1 2 3 4 5 6 7 8 9 : ; < = > ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ] ^ _ ` a b c d e f g h i j k l m n o p q r s t u v w x y z { | } ~ <del>
C_11 := ...........
C_32 := ................................

comma := ,
space := 
space += 

head = $(firstword $1)
last = $(lastword $1)
tail = $(wordlist 2, $(words $1),$1)
rtail = $(wordlist 1, $(words $(call tail,$1)),$1)

count = $(words $(subst .,. ,$1))
count_sub1 = $(words $(subst .,. ,$(patsubst .%,%,$1)))
count_add1 = $(words $(subst .,. ,$1.))

dec_wrap = $(if $(call filter,$1,.),$(MAX),$(patsubst .%,%,$1))
inc_wrap = $(if $(call filter,$1,$(MAX)),.,$1.)

write = $(eval OUT_BUFFER := $(OUT_BUFFER)$1)
flush = $(or $(info $(OUT_BUFFER)),$(eval OUT_BUFFER := ))
print = $(if $(filter $(C_11),$1),$(call flush),$(if $(filter $(C_32),$1),$(call write, ),$(if $(findstring $(C_32).,$1),$(call write,$(word $(call count_add1,$(patsubst $(C_32).%,%,$1)),$(ALPHABET))))))

read = $(shell read -n 1 -s a; echo $$a)
rconvchr = $(if $2,$(if $(filter $1,$(call head,$2)),$3,$(call rconvchr,$1,$(call tail,$2),$3.)),$(C_32))
convchr = $(call rconvchr,$1,$(ALPHABET),$(C_32).)

getch = $(call convchr,$(call read))

listget = $(word $(call count,$1),$2)

memget = $(call listget,$(PTR),$(MEM))
memset = $(eval MEM := $(wordlist 1,$(call count_sub1,$(PTR)),$(MEM)) $1 $(wordlist $(call count_add1,$(PTR)),$(words $(MEM)),$(MEM)))
memdump = $(foreach cell,$(MEM),$(call count_sub1,$(cell)))

incpc = $(eval PC := $(PC).)
setpc = $(eval PC := $1)
fetch = $(word $(call count,$(PC)),$(PROG))

fc-open = $(call find-close,$1.,$2.,$(call tail,$3))
fc-close = $(if $2,$(call find-close,$1.,$(patsubst .%,%,$2),$(call tail,$3)),$1)
find-close = $(if $3,$(if $(filter $(call head,$3),[),$(call fc-open,$1,$2,$3),$(if $(filter $(call head,$3),]),$(call fc-close,$1,$2,$3),$(call find-close,$1.,$2,$(call tail,$3)))),$(error No matching ]))
jmpfwd = $(call setpc,$(call find-close,$(PC),,$(wordlist $(call count,$(PC).),$(words $(PROG)),$(PROG))).)

fo-open = $(if $2,$(call find-open,$(patsubst .%,%,$1),$(patsubst .%,%,$2),$(call rtail,$3)),$1)
fo-close = $(call find-open,$(patsubst .%,%,$1),$2.,$(call rtail,$3))
find-open = $(if $3,$(if $(filter $(call last,$3),[),$(call fo-open,$1,$2,$3),$(if $(filter $(call last,$3),]),$(call fo-close,$1,$2,$3),$(call find-open,$(patsubst .%,%,$1),$2,$(call rtail,$3)))),$(error No matching [))
jmpbck = $(call setpc,$(patsubst .%,%,$(call find-open,$(PC),,$(wordlist 1,$(call count_sub1,$(PC)),$(PROG)))))

inc = $(call memset,$(call inc_wrap,$(call memget)))
dec = $(call memset,$(call dec_wrap,$(call memget)))
left = $(eval PTR := $(call dec_wrap,$(PTR)))
right = $(eval PTR := $(call inc_wrap,$(PTR)))
in = $(call memset,$(call getch))
out = $(call print,$(call memget))
# out = $(info $(call count_sub1,$(call memget)))
open = $(if $(filter $(call memget),.),$(call jmpfwd))
close = $(if $(filter $(call memget),.),,$(call jmpbck))

exec = $(if $(filter $1,+),$(call inc),$(if $(filter $1,-),$(call dec),$(if $(filter $1,<),$(call left),$(if $(filter $1,>),$(call right),$(if $(filter $1,.),$(call out),$(if $(filter $1,$(comma)),$(call in),$(if $(filter $1,[),$(call open),$(if $(filter $1,]),$(call close)))))))))
step = $(or $(call incpc),$(if $(fetch),$(call exec,$(fetch)),stop))

l1 = $(if $(call filter,$(call count,$(LC1)),100),,$(or $(eval LC1 := $(LC1).),$(or $(call step),$(call $0))))
l2 = $(if $(call filter,$(call count,$(LC2)),100),,$(or $(eval LC2 := $(LC2).),$(or $(call l1),$(or $(eval LC1 := ),$(call $0)))))
l3 = $(if $(call filter,$(call count,$(LC3)),100),,$(or $(eval LC3 := $(LC3).),$(or $(call l2),$(or $(eval LC2 := ),$(call $0)))))
l4 = $(if $(call filter,$(call count,$(LC4)),100),,$(or $(eval LC4 := $(LC4).),$(or $(call l3),$(or $(eval LC3 := ),$(call $0)))))

_ := $(call l4)
_ := $(call flush)
_ := $(info $(call memdump))
