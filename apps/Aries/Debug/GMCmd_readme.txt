---++ Game Manager(GM) commands in Aries

---+++ GM enter command
in the chat window, type gm commands superceeded by /gm, such as 
<verbatim>
/gm addexp 100
</verbatim>

---+++ Programmer adding new gm command
To add new command, simply edit "GMCmd_Server.lua".
Usually there is NO need to edit "GMCmd_Client.lua", which automatically translate to server message using the following rule
<verbatim>
cmd_name [cmd_target] [any_numer_string_or_table_format]
e.g. "addexp self 100" --> msg {type="addexp", data={target="self", value=100}}
     "addexp 100" --> msg {type="addexp", data={value="100"}}
     "additem 123_nid {a=1,b=2}" --> msg {type="additem", data={target="123_nid",a=1, b=2}}
     "additem {a=1,b=2}" --> msg {type="additem", data={a=1, b=2}}
</verbatim>

---+++ Character related

---++++ addexp 
| author | LiXizhi|
| alias  | exp |
<verbatim>
/gm addexp 100
	add 100 exp to current player
/gm addexp 14861822 100
	add 100 exp to user nid 14861822
</verbatim>

---++++ additem
| author | LiXizhi|
| alias  | purchaseitem add buy |
<verbatim>
/gm add self 魔豆 100
   add item whose name is 魔豆 of count 100
/gm add 14861822 money 100
   add money item of count 100 to user nid 14861822
/gm buy self 1001 
   add 1 gsid item 1001 to current user.
</verbatim>

---++++ add self money 10000
add 魔豆 money for current user

---++++ addpetexp 
| author | LiXizhi|
| alias  | pet |
<verbatim>
/gm pet self 胖雪人 1000
   add exp to a pet that a user owns
</verbatim>

---++++ deleteme
| author | LiXizhi |
| alias  | suicide |
重置角色
<verbatim>
/gm deleteme
</verbatim>

---+++ Quick Guide
<verbatim>
/gm add self 胖雪人
/gm add self money 100
/gm pet self 胖雪人 1000
</verbatim>