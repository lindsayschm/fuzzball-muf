( CorkBoard by Kelketek of Winter's Oasis. Replacement for gen-mesgboard.
  Allows for MUCK-wide announcements of posts, notifications of unread posts
  at log-in, read checklist, subscriptions, post restrictions, mesage API.
  
  Copyright [c] 2011, Kelketek of Winter's Oasis
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
      * Neither the name of Kelketek nor Winter's Oasis nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL KELKETEK OR WINTER'S OASIS BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  [INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION] HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  [INCLUDING NEGLIGENCE OR OTHERWISE] ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  
  Wizards:
  To set up this program:
  Compile it, and @register it as gen/CorkBoard
  @set $gen/CorkBoard=M3
  @set $gen/CorkBoard=L
  @propset #0=dbref:_connect/CorkBoard:$gen/CorkBoard
  @set $gen/corkboard=_docs:@list $gen/corkboard=1-145
  
  Players:
  To set up a board, create an action named setup-board and attach it to the
  desired board. Then link it to the program and run it, following
  instructions. For example:
  
  @create CorkBoard
  @act setup-board=CorkBoard
  @link setup-board=$gen/CorkBoard
  setup-board
  
  Advanced set up note:
  You can use a DBREF for the board other than the object the action is
  attached to by doing
  @set setup-board=_board/boarddb:123
  ...where 123 is the DBREF of the desired board location.
  
  I already have a board with gen-mesgboard. I don't want to lose my posts!:
  Fear not, netizen! All you must do is create this action on yourself:
  @act convert-board=me
  then,
  @link convert-board=$gen/corkboard
  and then run that command. Follow the instructions, and your messages
  and settings will be ported. When you have converted all the boards you
  wish, simply @recycle the command.
  
  A couple of notes about conversion:
  1. The timestamps of your old posts will only be accurate within a day.
  Decoding the written out stamps fully would make this program double in
  size.
  2. Keywords have been dropped. I don't know anyone who uses them. If you
  do, please find me on muck.wintersoasis.com port 8888 and we'll work it into
  the next release.
  3. The original messages will remain. They exist as the dirs 'msgs' and
  'msgs#' on the original board object.
  
  Oops! I accidentally recycled my action. Now what?:
  Go to your board item and clear the 'trigger' property under _board/prefix/
  where prefix is the prefix you set for your board. The default prefix is
  'main'. Set the property again with the new exit's DBREF.
  Note, though, that all subscription records concerning the board will be
  reset if the DBREF of the new action differs from the old one. Also,
  if they have connected or run +mcheck since the erasure, records of read
  posts will be removed, leaving all messages unread again.
  
  Programmers: An API has been included for working with CorkBoard.
  The following terms are used in the API arguments:
  
  Boardaction is the DBREF of the action used to access a CorkBoard
  PostNumber is the number of a post when you read a board
  PostID is the unique ID number of a post for direct manipulation
  Content is the content of the message
  Poster/Owner is the one who owns or posts a post.
  Title/Name is the name of the post.
  SuccessOrFailure is either a 1 for the command completing successfully
  or a 0 otherwise.
  
  Please take note of the following public functions:
  make-CorkBoard-post:
  [ dbref:boardaction str:title dbref:owner arr:content -- 
  str:Error/PostID int:SuccessOrFailure ]
  Allows you to make a post to a board
  get-CorkBoard-PostID:
  [ dbref:boardaction int:postNumber -- str:postID ]
  gets the ID of a CorkBoard post from its listed number
  get-CorkBoard-post:
  [ dbref:boardaction str:postID --
  arr:{ str:name, dbref:owner, arr:contents }dict ]
  Gets a CorkBoard post.
  get-all-CorkBoard-posts:
  [ dbref:boardaction -- arr:{ str1:postID str1b:name dbef1:owner
  arr1:{contents}... strx: postID strxb:name dbrefx:owner arrx:{contents} } ]
  del-CorkBoard-post:
  [ dbref:boardaction str:postID -- int:SuccessOrFailure ]
  Deletes a CorkBoard post.
  protect-CorkBoard-post:
  [ dbref:Boardaction string:postID -- int:SuccessOrFailure ]
  Sets a CorkBoard post as protected
  unprotect-CorkBoard-post:
  [ dbref:Boardaction string:postID -- int:SuccessOrFailure ]
  Sets a CorkBoard post as unprotected
 
  Additionally, you can set the program to notify a set of DBREFs whenever a
  message is posted to the board in this format:
  CorkBoard>#123:1303683740#456
  Where #123 is the DBREF of the action and 1303683740#456 is the post ID.
  This allows you to trigger events to occur with _listen programs when a
  post is made. DBREFs that are notifed must have this prop set on them:
  _board/listener?:1
  You can set the DBREFs to be notified on the 'listeners' subprop of
  the board in a space delimited set. For example:
  @set BoardObject=_board/main/listeners:#123 #456 #789
  Assuming, of course, that your board is under the default prefix 'main'. 
  
  Version History:
  1.0 Initial release.
  1.1 Removal of bug where unsubscribe didn't quite fully unsubscribe.
  1.5 Change in how read posts are stored to avoid conflicts on larger MUCKs.
  1.6 Addition of 'read -' to read next unread message, and clean-up routine
  for dead boards better implemented. Messages markers from dead boards are
  now removed from the player on connect.
  1.7 Fixed buggy routine for dealing with old gen-mesgboard proplists
  1.75 Made it to where guests only have denied access to posting. The normal
  perms will keep them out of anything else anyway.
  1.8 Added an alias for 'delete': 'erase'. This is because erase was the
  command used in gen-mesgboard, and so we should have it. Also added the
  number of the post to check when broadcasting.
  
  Please contact kelketek@gmail.com for any bug reports or feature requests. )
 
$def root "_board/"
$def board trigger @ root "boarddb" strcat getpropstr stod dup not if pop trigger @ location then
$def dir trigger @ root "dir" strcat getpropstr dup not if pop "_board/main/" else "_board/" swap strcat "/" strcat then ( This definition allows for alternate boards, and a default placement otherwise. )
$def prefix dir "mesg/" strcat swap strcat
$def version "1.7-FB"
$def ifnstring dup string? not if intostr then
 
$include $lib/editor
$include $lib/case
$include $lib/strings
lvar mainarg
lvar newpost
lvar newproppfx
lvar newcmdpfx
lvar mcheck
lvar content
lvar title
lvar postID
lvar converting?
lvar testref
lvar readnextunread
 
: checkperms
me @ board owner dbcmp
me @ "staff" flag? or
me @ "W" flag? or
if 1 else 0 then
;
 
: Cork-num-from-ID ( s -- s )
var! compare
var counter
{ board dir "mesg/" strcat array_get_propvals array_keys pop }list
foreach
     counter @ ++ counter !
     swap pop 
     compare @ stringcmp not if
         break
     then
repeat
counter @ intostr
;
 
: Cork-ID-from-num ( i -- s )
1 -
{ board dir "mesg/" strcat array_get_propvals array_keys pop }list
{ swap foreach
swap pop atoi
repeat }list 1 array_sort ( convert to integers to sort, and then back again. )
{ swap foreach
swap pop intostr
repeat }list swap array_getitem ifnstring dup "0" strcmp not if pop "" then dup postID !
;
 
: catch-up ( -- ) ( Marks all messages as read. )
{ board dir "mesg/" strcat array_get_propvals array_keys pop }list ( Get all of the board items )
foreach
     swap pop root trigger @ intostr "/" strcat strcat swap strcat me @ swap 1 setprop
repeat
{ "Marked all messages on \"" board dir "boardname" strcat getpropstr "\" as read." }cat .tell
;
 
: notifysubscribers ( -- )
#0 root "subscriptions" strcat trigger @ reflist_find if
     online_array foreach ( Notifyone except those who have opted-out about new messages. Don't tell the poster, either, as we've already done that explicitly. )
          swap pop dup me @ dbcmp if pop continue then dup root "opt-out" strcat trigger @ reflist_find not if
               { "[!] " me @ " has posted a new message entitled \"" board newpost @ "name" strcat getprop "\" in board \"" board dir "boardname" strcat getprop "\"."
               trigger @ name dup ";" instring 1 - strcut pop dup match trigger @ dbcmp if
                    " Type '" swap " " newpost @ Cork-num-from-ID "' to read it."
               else
                    pop
               then
               }cat notify
          else
               pop
          then
     repeat
else
     online_array foreach ( Notify only subscribers. Don't tell the poster, either, as we've already done that explicitly. )
          swap pop dup dup me @ dbcmp if pop pop continue then root "subscriptions" strcat trigger @ reflist_find if
               { "[!] " me @ " has posted a new message entitled \"" board newpost @ "name" strcat getprop "\" in board \"" board dir "boardname" strcat getprop "\"."
               trigger @ name dup ";" instring 1 - strcut pop dup match trigger @ dbcmp if
                    " Type '" swap " " newpost @ Cork-num-from-ID "' to read it."
               else
                    pop
               then
               }cat notify
          else
               pop
          then
     repeat
then
board dir "listeners" strcat array_get_reflist
foreach
     swap pop dup root "listener?" strcat getprop if
          { "CorkBoard>" trigger @ ifnstring "#" swap strcat ":" postID @ }cat notify
     else
          pop
     then
repeat
;
 
: lister ( -- ) ( Lists the items on the board. )
"+----------------------------------------------------------------------------+" .tell
{ board dir "mesg/" strcat array_get_propvals array_keys pop }list
{ swap foreach
swap pop atoi
repeat }list 1 array_sort ( convert to integers to sort, and then back again. )
{ swap foreach
swap pop intostr
repeat }list 
var item
var count
foreach
     swap pop count @ ++ count ! postID ! postID @ prefix "/" strcat item ! { {
     "|"
     board item @ "protected?" strcat getprop if "#" then
     me @ { root trigger @ intostr "/" postID @ }cat getprop not if "*" then ( Mark with a star if it hasn't been read before. )
     count @ ( Item number on the list. ) ". "
     board item @ "name" strcat getpropstr }cat 60 STRleft 60 strcut pop { "|"
     board item @ "owner" strcat getpropstr stod dup player? not if dup program? not if pop "(Toaded Player)" else name then else name then 16 STRcenter 16 strcut pop "|" }cat  }cat .tell
repeat
"+----------------------------------------------------------------------------+" .tell
{ "| Type '" trigger @ name dup ";" instr strcut pop dup "read" instring 1 - strcut pop "help' for a list of commands." }cat 78 STRleft "|" strcat .tell
"+----------------------------------------------------------------------------+" .tell
;
 
: reader ( -- ) ( Reads a post, marks it read. )
var item
var counter
readnextunread @  not if
     mainarg @ atoi counter ! counter @
     Cork-ID-from-num dup not if
          pop "No such board post." .tell exit
     then
     postID !
else
     { board dir "mesg/" strcat array_get_propvals array_keys pop }list
     { swap foreach
          swap pop atoi
     repeat }list 1 array_sort ( convert to integers to sort, and then back again. )
     { swap foreach
          swap pop intostr
     repeat }list
     foreach
          counter @ ++ counter !
          swap pop item !
          me @ { root trigger @ intostr "/" item @ }cat getprop not if break then
          0 item !
     repeat
then
readnextunread @ item @ not and if
     "No unread post to display." .tell exit
else
     item @ if
          item @ postID ! postID @
     else
          postID @
     then
then
"/" strcat prefix var! item
me @ { root trigger @ intostr "/" postID @ }cat 1 setprop ( Mark this item as read before continuing. )
me @ { root trigger @ intostr }cat "y" setprop ( Marks this propdir as active, so we can remove it if the board is ever removed. )
" " .tell
{ counter @ ". From: " board item @ "owner" strcat getpropstr stod dup player? not if dup program? not if pop "(Toaded Player)" else name then else name then }cat .tell
{ "On: " postID @ atoi "%Y-%m-%d %T" swap timefmt }cat .tell ( Extract the post time from the message ID )
{ board dir "expiration" strcat getprop dup if
     atoi var! timer
     board item @ "protected?" strcat getprop if
          "This post is protected from expiration."
     else
          "This post will expire on: " postID @ atoi board dir "expiration" strcat getpropstr atoi + var! postexptime postexptime @ "%Y-%m-%d %T" swap timefmt " -- "
          postexptime @ systime - 
          var! timeleft 
           timeleft @ 86400 / dup " days, " swap 86400 * timeleft @ swap - timeleft ! ( calculate days )
           timeleft @ 3600 / dup " hours, " swap 3600 * timeleft @ swap - timeleft ! ( calculate hours )
           timeleft @ 60 / dup " minutes, and " swap 60 * timeleft @ swap - timeleft ! ( calculate minutes )
           timeleft @ " seconds from now." ( Seconds are left over. )
     then
else
     pop
then }cat .tell
{ "Subject: " board item @ "name" strcat getprop }cat .tell
" " .tell
board item @ "content" strcat array_get_proplist
foreach ( Display the contents of the post )
     swap pop intostr .tell
repeat
" " .tell
;
 
: editpost ( -- )
mainarg @ atoi
Cork-ID-from-num dup not if
     pop "No such board post." .tell exit
then
prefix var! item
board item @ "/owner" strcat getpropstr stod me @ dbcmp not if ( Make sure this player owns this post first. If not, check for moderator permissions. )
     checkperms not if
          "Permission denied." .tell exit
     then
then
board item @ "/name" strcat getpropstr title !
{ "This post is currently named '" title @ "'. Enter a new title or '.' for no change." }cat .tell
read
dup "." strcmp not if
     pop
else
     title !
then
{ board item @ "/content" strcat array_get_proplist array_vals EDITOR "end" stringcmp not if ( Save the list. )
     pop }list
     board item @ "/content" strcat rot array_put_proplist
     board item @ "/name" strcat title @ setprop
else
     pop "Message not saved!" .tell exit
then
;
 
: do-post ( -- ) ( Makes a post. )
begin
     systime ifnstring postID ! postID @ prefix newpost ! ( If someone is uploading a few posst at once, we don't want them stepping over one another. )
     board newpost @ getprop not if break else 2 sleep then
repeat
newpost @ "/" strcat newpost !
board newpost @ "name" strcat title @ setprop
board newpost @ "owner" strcat me @ setprop
board newpost @ "content" strcat content @ array_put_proplist
board newpost @ strlen 1 - newpost @ swap strcut pop 1 setprop
notifysubscribers
{ "[!] " me @ " has posted a new message entitled \"" board newpost @ "name" strcat getprop "\" in board \"" board dir "boardname" strcat getprop "\"."
trigger @ name dup ";" instring 1 - strcut pop dup match trigger @ dbcmp if
" Type '" swap " " newpost @ Cork-num-from-ID "' to read it."
     else
          pop
     then
}cat .tell
;
 
: post-perm-check
board dir "blacklist" strcat me @ reflist_find me @ board controls not and if
     "You have been banned from posting on this board." .tell 0 exit
then
board dir "restricted?" strcat getprop if
     board dir "whitelist" strcat me @ reflist_find
     board owner me @ dbcmp or not if
          "You are not authorized to post on this board." .tell 0 exit
     then
then
1
;
 
: makepost ( -- )
me @ "guest" flag? me @ name "Guest" instr or if
     "Sorry, this command not available to Guests." .tell exit ( This might tick off someone named EverGuest on Furry if he were to run accross it. If you have a better method for your server, patch here :] )
then
post-perm-check not if exit then
"What will be the title of this post?" .tell
read title !
{ 0 EDITOR swap pop var! exitcmd }list exitcmd @
"end" stringcmp not if
     content !
     do-post
else
     "Aborted." .tell pop exit
then
;
 
: do-delete
var! item
board item @ prefix "/" strcat remove_prop
;
 
: unread ( -- ) ( Marks a post as unread )
mainarg @ atoi
Cork-ID-from-num dup not if
     pop "No such board post." .tell exit
then
me @ { root trigger @ intostr "/" PostID @ }cat remove_prop
{ "Post entitled \"" board PostID @ prefix "/name" strcat getpropstr "\" marked unread." }cat .tell
;
 
: clean-up ( -- ) ( Clears out markers on a person for board entries that don't exist anymore. Also removes expired posts. )
board dir "expiration" strcat getpropstr dup if
     var! timer
     { board dir "mesg/" strcat array_get_propvals array_keys pop }list
     foreach
          swap pop postID ! board postID @ prefix "/protected?" strcat getprop not if
               postID @ dup atoi systime swap - timer @ atoi >= if
                    postID @ do-delete
               else
                   pop
               then
          then
     repeat
else
     pop
then
me @ { root trigger @ intostr "/" }cat array_get_propvals { swap array_keys pop }list
var currentprop
foreach
     swap pop currentprop ! board currentprop @ prefix getprop not if
          me @ { root trigger @ intostr "/" currentprop @ }cat remove_prop
     then
repeat
;
 
: subscribe ( -- ) ( subscribes to a board for its announcements. )
me @ root "subscriptions" strcat array_get_reflist { }list array_union ( Cleans reflist, remove duplicates. )
me @ root "subscriptions" strcat rot array_put_reflist
me @ root "subscriptions" strcat trigger @ reflist_add
me @ root "opt-out" strcat array_get_reflist { }list array_union
me @ root "opt-out" strcat rot array_put_reflist
me @ root "opt-out" strcat trigger @ reflist_del
{ "Subscribed to " board dir "boardname" strcat getprop "." }cat .tell
;
 
: unsubscribe ( -- ) ( unsubscribes to a board for its announcements. )
me @ root "subscriptions" strcat array_get_reflist { trigger @ }list swap array_diff { }list array_union ( clean up the reflist, removing duplicates, and the board to unsubscribe from )
me @ root "subscriptions" strcat rot array_put_reflist
me @ root "subscriptions" strcat trigger @ reflist_del 
#0 root "subscriptions" strcat trigger @ reflist_find if ( Only put the ref on opt-out if the board is global. That way, if the board one day becomes especially important and added to the global subscriptions, they will still recieve notifications until they decide to unsubscribe once more. )
     me @ root "opt-out" strcat trigger @ reflist_add
     me @ root "opt-out" strcat array_get_reflist { }list array_union ( But of course, let's clean up and remove duplicates. )
     me @ root "opt-out" strcat rot array_put_reflist
then
{ "Unsubscribed from " board dir "boardname" strcat getprop "." }cat .tell
;
 
: deletepost ( -- ) ( Deletes a post from the board )
mainarg @ atoi
Cork-ID-from-num
dup not if
     "No such post." .tell exit
then
postID !
postID @ prefix "/" strcat var! item
board item @ "owner" strcat getpropstr stod me @ dbcmp not if ( Make sure this player owns this post first. If not, check for moderator permissions. )
     checkperms not if
          "Permission denied." .tell exit
     then
then
{ "Are you sure you want to delete the post entitled \"" board item @ "name" strcat getpropstr "\"?" }cat .tell
read
.yes? not if
     "Aborted." .tell exit
then
postID @ do-delete
"Post deleted." .tell
;
 
: disallowuser ( -- )
checkperms not if
     "Permission denied." .tell exit
then
mainarg @ 1 try pmatch catch { "Syntax: " command @ " playername" }cat .tell exit endcatch
dup player? not if
     pop "Target ambiguous, nonexistant, or not a player." .tell exit
then
var! target
board dir "whitelist" strcat target @ reflist_del
{ "User " target @ " removed from the permitted posters list.." }cat .tell
;
 
: allowuser ( -- )
checkperms not if
     "Permission denied." .tell exit
then
mainarg @ 1 try pmatch catch { "Syntax: " command @ " playername" }cat .tell exit endcatch
dup player? not if
     pop "Target ambiguous, nonexistant, or not a player." .tell exit
then
var! target
board dir "whitelist" strcat target @ reflist_add
{ "User " target @ " added to the permitted posters list." }cat .tell
;
 
: unbanuser ( -- )
checkperms not if
     "Permission denied." .tell exit
then
mainarg @ 1 try pmatch catch { "Syntax: " command @ " playername" }cat .tell exit endcatch
dup player? not if
     pop "Target ambiguous, nonexistant, or not a player." .tell exit
then
var! target
board dir "blacklist" strcat target @ reflist_del
{ "User " target @ " unbanned." }cat .tell
;
 
: banuser ( -- ) ( Bans a user from the board. )
checkperms not if
     "Permission denied." .tell exit
then
mainarg @ 1 try pmatch catch { "Syntax: " command @ " playername" }cat .tell exit endcatch
dup player? not if
     pop "Target ambiguous, nonexistant, or not a player." .tell exit
then
var! target
board dir "blacklist" strcat target @ reflist_add
{ "User " target @ " banned." }cat .tell
;
 
: boardnamer ( -- ) ( Sets the board's name )
" " .tell
"What will you name this board?" .tell
read board dir "boardname" strcat rot setprop
;
 
: do-unprotect[ str:postID -- ]
board postID @ prefix "/protected?" strcat remove_prop
;
 
: do-protect[ str:postID -- ]
board postID @ prefix "/protected?" strcat 1 setprop
;
 
: unprotect
mainarg @ atoi
Cork-ID-from-num dup not if
     pop "No such post." .tell exit
else
     postID !
then
board postID @ prefix "\owner" strcat getpropstr stod me @ dbcmp checkperms or if
     postID @ do-unprotect { "Post \"" board postID @ prefix "/name" strcat getpropstr "\" by " board postID @ prefix "/owner" strcat getpropstr stod " in \"" board dir "boardname" strcat getpropstr "\" no longer protected." }cat .tell
else
     "You are not authorized to unprotect posts on this board." .tell exit
then
;
 
: protect ( -- )
mainarg @ atoi
Cork-ID-from-num dup not if
     pop "No such post." .tell exit
else
     postID !
then
checkperms if
     postID @ do-protect { "Post \"" board postID @ prefix "/name" strcat getpropstr "\" by " board postID @ prefix "/owner" strcat getpropstr stod " in \"" board dir "boardname" strcat getpropstr "\" protected." }cat .tell
else
     "You are not authorized to protect posts on this board." .tell exit
then
;
 
: boardrestrictor ( -- ) ( Sets the board to restricted posting only. )
board dir "restricted?" strcat getprop not board dir "restricted?" strcat rot setprop
;
 
: broadcastswitch ( -- )
#0 root "subscriptions" strcat trigger @ reflist_find if
     #0 root "subscriptions" strcat trigger @ reflist_del
else
     #0 root "subscriptions" strcat trigger @ reflist_add
then
;
 
: propsanitize ( s -- s ) ( When the player inputs a prop prefix, let's make sure it makes sense. )
strip "-" " " subst "-" "/" subst "-" "." subst "-" "@" subst "-" "~" subst
;
 
: set-up ( -- )
board root "main/trigger" strcat getpropstr stod if
     begin
          "This object already has a board. Enter a new propdir prefix for the new board, for instance, 'news', or type '.q' to quit." .tell
          read dup ".q" stringcmp not if pop
               "Setup Aborted." .tell 0 exit
          then
          propsanitize newproppfx !
          board root newproppfx @ strcat "/trigger" strcat getprop if
               "That prefix is already in use." .tell 0
          else
               1
          then
     until
then
trigger @ name dup "read" instring dup if ( This is more for keeping the naming structure of conversions than anything. )
     1 - strcut pop newcmdpfx !
then
newcmdpfx @ not if
     "+read" match trigger @ dbcmp not if
          begin
               "The default action prefix is already in use, or there is no prefix. Enter a new one. For instance, enter '+bb' to create +bbread, +bbwrite, etc, or type '.q' to quit." .tell
               read dup ".q" stringcmp not if pop
                    "Setup Aborted." .tell 0 exit
               then
               newcmdpfx !
               newcmdpfx @ "read" strcat name-ok? not if
                    "Prefix invalid. Try using a short set of letters." .tell 0
               else
                    newcmdpfx @ "read" strcat match if
                         "That command prefix is already taken." .tell 0
                    else
                         1
                    then
               then
          until
     else
     "+" newcmdpfx !
     then
then
trigger @ { newcmdpfx @ "read" ";" newcmdpfx @ "write" ";" newcmdpfx @ "edit" ";" newcmdpfx @ "catchup" ";" newcmdpfx @ "unread" ";" newcmdpfx @ "unban" ";" newcmdpfx @ "ban" ";" newcmdpfx @ "disallow" ";" newcmdpfx @ "allow" ";" newcmdpfx @ "delete" ";" newcmdpfx @ "erase" ";" newcmdpfx @ "unsubscribe" ";" newcmdpfx @ "subscribe" ";" newcmdpfx @ "mcheck" ";" newcmdpfx @ "unprotect" ";" newcmdpfx @ "protect" ";" newcmdpfx @ "configure" ";" newcmdpfx @ "help" }cat setname
trigger @ location "_bbsloc" getpropstr dup not if
     pop
     trigger @ "_bbsloc" getpropstr dup not if
          pop
     else
          trigger @ root "boarddb" strcat rot setprop
     then
else
     trigger @ root "boarddb" strcat rot setprop
then
 
newproppfx @ if
     trigger @ root "dir" strcat newproppfx @ setprop
     board dir "trigger" strcat trigger @ setprop
else
     board dir "trigger" strcat trigger @ setprop
then
{ "Action setup-bbard renamed to " newcmdpfx @ "read. Type '" newcmdpfx @ "configure' to configure your new board. Then type '" newcmdpfx @ "help' for a full list of commands and their uses." }cat .tell
"Board Constructed." .tell
1
;
 
: setexpiration ( -- ) ( Sets the expiration time for old messages. )
"Enter how many days unprotected posts last, 'q' for no change, or 'n' for no expiration." .tell
read var! choice
choice @ "q" instring if "Aborted." .tell exit then
choice @ "n" instring if
     "Expiration time cleared." .tell
     board dir "expiration" strcat remove_prop
     exit
then
choice @ atoi not if
     "Expiration time cleared." .tell
     board dir "expiration" strcat remove_prop
     exit
else
     "Expiration time set." .tell
     board dir "expiration" strcat choice @ atoi 86400 * intostr setprop
     exit
then
;
 
: configure ( -- )
var complete
me @ board controls not if
     "You are not authorized to configure this board." .tell exit
then
begin
     " " .tell
     { "1. " board dir "boardname" strcat getpropstr dup not if pop "This board's name must be set." else "This board's name is: " swap then }cat .tell
     { "2. " board dir "restricted?" strcat getprop not if "This board is available for public posting." else "This board is restricted to certain posters only." then }cat .tell
     { "3. " board dir "expiration" strcat getpropstr dup if "Unprotected messages expire after " swap atoi 86400 / dup " day" swap 1 > if "s" then "." else "Messages do not expire." then }cat .tell
     me @ "wizard" flag? if { "4. This board is " #0 root "subscriptions" strcat trigger @ reflist_find not if "NOT " then "set up for public broadcast." }cat .tell then
     "Q. Save configuration and exit." .tell
     " " .tell
     "Please select an option." .tell
read
case
     atoi 1 = when boardnamer end
     atoi 2 = when boardrestrictor end
     atoi 3 = when setexpiration end
     atoi 4 = when me @ "wizard" flag? if broadcastswitch else "Invalid option." .tell then end
     "q" instring when "Configuration saved." .tell 1 complete ! end
     default "Invalid option." .tell end
endcase
complete @
until
board dir "boardname" strcat getprop not if
     "Board configuration incomplete." .tell
else
     board dir "configured?" strcat 1 setprop
then
;

: subcleanup ( -- ) ( Removes dead entries from the #0 global subscriptions, the player's personal subscriptions, and their opt-out list. Also cleans out entries from boards that no longer exist. )
trigger @ var! triggerback
#0 root "subscriptions" strcat array_get_reflist
foreach
     swap pop testref ! testref @ 1 try
          dup dup trigger ! board dir "trigger" strcat getpropstr stod dbcmp not if ( Checks to see if a DB on the reflist is a legit trigger for a board. if not, removes it from the reflist. )
               #0 root "subscriptions" strcat rot reflist_del
          else
               pop
          then
     catch
          pop #0 root "subscriptions" strcat testref @ reflist_del
     endcatch
repeat
me @ root "subscriptions" strcat array_get_reflist
foreach
     swap pop testref ! testref @ 1 try
          dup dup trigger ! board dir "trigger" strcat getpropstr stod dbcmp not if ( Checks to see if a DB on the reflist is a legit trigger for a board. if not, removes it from the reflist. )
               me @ root "subscriptions" strcat rot reflist_del
          else
               pop
          then
     catch
          pop me @ root "subscriptions" strcat testref @ reflist_del
     endcatch
repeat
me @ root "opt-out" strcat array_get_reflist
foreach
     swap pop testref ! testref @ 1 try
          dup dup trigger ! board dir "trigger" strcat getpropstr stod dbcmp not if ( Checks to see if a DB on the reflist is a legit trigger for a board. if not, removes it from the reflist. )
               me @ root "opt-out" strcat rot reflist_del
          else
               pop
          then
     catch
          pop me @ root "opt-out" strcat testref @ reflist_del
     endcatch
repeat
me @ root array_get_propvals
foreach
      ifnstring .yes? not if
           pop continue
      then
      stod trigger ! trigger @ 1 try
           dup dup trigger ! board dir "trigger" strcat getpropstr stod dbcmp not if
                me @ { root trigger @ intostr }cat remove_prop
                me @ { root trigger @ intostr "/" }cat remove_prop
           else
                pop
           then
      catch
           pop
           me @ { root trigger @ intostr }cat remove_prop
           me @ { root trigger @ intostr "/" }cat remove_prop
      endcatch
repeat
triggerback @ trigger !
;
 
: connectannounce ( Lets users know what messages they have yet to read on board they're connected to at startup. )
subcleanup
me @ "guest" flag? if
     exit
then
mcheck @ not if
     2 sleep
else
     "Checking for new messages..." .tell
then ( Proto is slow on running look compared to other servers. Sleep here serves to make sure the messages come after the room desc. Sleep is skipped if this is just standard mcheck )
 
me @ root "opt-out" strcat array_get_reflist
#0 root "subscriptions" strcat array_get_reflist array_diff
me @ root "subscriptions" strcat array_get_reflist array_union ( Get all of the default subscriptions, minus opt-outs, and plus the user's personal subscriptions )
var counter
foreach
     swap pop trigger !
     { board dir "mesg/" strcat array_get_propvals array_keys pop }list ( Find all the ones with new messages, and announce! )
     foreach
          swap pop root trigger @ intostr strcat "/" strcat swap strcat me @ swap getprop not if
               counter @ ++ counter !
          then
     repeat
     counter @ if
          { "[!] You have " counter @ " unread message" counter @ 1 > if "s" then " in: " board dir "boardname" strcat getprop "."
          trigger @ name dup ";" instring 1 - strcut pop dup match trigger @ dbcmp if
               " Type '" swap "' to check the board." ( If the command for reading messages is in the environment of the player, tell him how to read it. )
          else
               pop
          then
          }cat .tell
          0 counter !
     then
repeat
;
 
: get-CorkBoard-postID[ dbref:boardaction int:postNumber -- str:postID ]
trigger @ var! oldtrigger
boardaction @ trigger !
postNumber @
Cork-ID-from-num ( Will return a null string if there's no match )
;
 
: get-CorkBoard-post[ dbref:boardaction str:postID -- arr:{ str1:postID str:name, dbref:owner, arr:content }dict ]
trigger @ var! oldtrigger
boardaction @ trigger !
{ 
"postID" postID @
"name" board postID @ prefix "/name" strcat getpropstr
"owner" board postID @ prefix "/owner" strcat getpropstr stod
"contents" board postID @ prefix "/content" strcat array_get_proplist
}dict
;
 
: make-CorkBoard-post[ dbref:boardaction str:posttitle dbref:owner arr:postcontent -- str:Error/PostID int:SuccessOrFailure ]
boardaction @ dbref? not if ( Do I trust people to pass me reasonable arguments? NO! )
     "Board action must be a dbref." 0 exit
then
owner @ dbref? not if
     "Owner must be DBREF." 0 exit
then
owner @ caller dbcmp not if
     owner @ "me" match dbcmp not if
          "Must post as user or program." 0 exit
     then
then
posttitle @ string? not if
     "Message name must be a string." 0 exit
then
posttitle @ title !
postcontent @ array? not if
     "Content must be an array." 0 exit
then
postcontent @ content !
trigger @ var! oldtrigger
boardaction @ trigger !
board dir "trigger" strcat getpropstr stod trigger @ dbcmp not if
     "Invalid board." 0 oldtrigger @ trigger ! exit
then
var oldme
me @ oldme !
owner @ me !
post-perm-check not if
     "Permission to post on this board denied for poster DBREF." oldme @ me ! oldtrigger @ trigger ! 0 exit
then
do-post
oldme @ me !
oldtrigger @ trigger !
postID @ 1
;
 
: protect-CorkBoard-post[ dbref:Boardaction string:postID -- int:SuccessOrFailure ]
trigger @ var! oldtrigger
boardaction @ trigger !
checkperms caller owner me ! checkperms "me" match me ! or if
     postID @ do-protect 1
else
     0
then
oldtrigger @ trigger !
;
 
: unprotect-CorkBoard-post[ dbref:Boardaction string:postID -- int:SuccessOrFailure ]
trigger @ var! oldtrigger
boardaction @ trigger !
checkperms caller owner me ! checkperms "me" match me ! or board postID @ prefix "/owner" strcat getpropstr stod me @ dbcmp or if
     postID @ do-unprotect 1
else
     0
then
oldtrigger @ trigger !
;
 
: del-CorkBoard-post[ dbref:boardaction str:postID -- int:SuccessOrFailure ]
trigger @ var! oldtrigger
boardaction @ trigger !
"me" match me !
board postID @ prefix "\owner" strcat getpropstr stod dup me @ dbcmp swap caller dbcmp or
checkperms caller owner me ! checkperms or
or if
     postID @ do-delete 1 "me" match me !
else
     0 "me" match me !
then
oldtrigger @ trigger !
;
 
: get-all-CorkBoard-posts[ dbref:boardaction -- arr:{ str1:postID str1b:name dbef1:owner arr1:{content}... strx: postID strxb:name dbrefx:owner arrx:{contents} } ]
trigger @ var! oldtrigger
boardaction @ trigger !
{ board dir "mesg/" strcat array_get_propvals array_keys pop }list
var item
{ swap
foreach
     swap pop item !
     { "postID" item @
     "title" board item @ prefix "/name" strcat getpropstr
     "owner" board item @ prefix "/owner" strcat getpropstr stod
     "content" board item @ prefix "/content" strcat array_get_proplist }dict
repeat
}list
oldtrigger @ trigger !
;
 
: convert-mesgboard ( -- )
1 converting? !
" " .tell
begin
"Please enter the command for reading on the old messageboard. For example, '+read' (the command must be accessable from where you currently are) or type '.q' to quit." .tell
read dup ".q" stringcmp not if
     pop "Conversion aborted." .tell exit
else
     var! readname readname @ match dup ok? not if
          pop "I don't see that here." .tell 0
     else
          dup name readname @ instring 1 - if
               pop "Invalid command, or the read command is not the first command alias." .tell pop 0
          else
               trigger ! 1
          then
     then
then
checkperms not if
     "You are not authorized to do this conversion." .tell exit
then
until
set-up not if
     exit
then
board "_expire" getpropstr dup if
     atoi 86400 * board dir "expiration" strcat rot setprop
else
     pop
then
var currentmsg
var currentmsgprop
var protectit?
var owner
var counter
0 try
"Converting messages..." .tell
board "msgs#" array_get_propvals "i" array_delitem foreach
     swap pop "msgs/" swap strcat "#" strcat board swap dup currentmsgprop ! currentmsgprop @ strlen 1 - strcut pop array_get_proplist
     0 array_delitem currentmsg ! ( The first prop is the message header which contains both unreliable and difficult to convert data. )
     board currentmsgprop @ "/i" strcat getprop ( Isolate the 'i' entry, which contains important info. )
     strip dup " " instr 1 - strcut swap pop ( Remove tags. Who uses those, anyway? )
     strip dup " " instr 1 - strcut swap atoi if 1 protectit? ! else 0 protectit? ! then
     strip dup " " instr 1 - strcut swap stod owner !
     strip dup " " instr  dup if 1 - strcut swap else pop then atoi 7800 + 86400 * counter @ + counter @ ++ counter ! ifnstring postID ! ( Assuming the standard offset of days, 7800, according to the def in gen-mesgboard header. Our time conversion will only be accurate within a day, however. Added in an incrementer to make sure even if posts are the same day, they're never the same ID. )
     depth 0 = if "( No subject )." then strip title !
     protectit? @ if
          postID @ do-protect
     then
     board postID @ prefix 1 setprop
     board postID @ prefix "/name" strcat title @ setprop
     board postID @ prefix "/owner" strcat owner @ setprop
     board postID @ prefix "/content" strcat currentmsg @ { swap array_vals pop }list array_put_proplist
     repeat
catch_detailed
     " " array_join .tell
     "Conversion incomplete or failed due to corrupted messages." .tell exit
endcatch
"Messages converted to CorkBoard format." .tell
trigger @ #-1 setlink
trigger @ prog setlink
"Read command relinked to CorkBoard." .tell
;
 
: do-help
trigger @ name dup ";" instr strcut pop dup "read" instring 1 - strcut pop var! cmdpfx
{
"+----------------------------------------------------------------------------+\r"
"|" "Welcome to CorkBoard version " version strcat 76 STRcenter "|\r"
"+----------------------------------------------------------------------------+\r"
"|" cmdpfx @ "read get a list of messages on the board." strcat 76 STRleft "|\r"
"|" "   * indicates an unread message, # indicates a protected message." strcat 77 STRleft "|\r"
"|" cmdpfx @ "read # to read a message, or - to get the next unread message." strcat 76 STRleft "|\r"
"|" cmdpfx @ "write to post a message to the board." strcat 76 STRleft "|\r"
"|" cmdpfx @ "edit # to edit a message on the board." strcat 76 STRleft "|\r"
"|" cmdpfx @ "unread to mark a message as unread." strcat 76 STRleft "|\r"
"|" cmdpfx @ "catchup to mark all messages on the board as read." strcat 76 STRleft "|\r"
"|" cmdpfx @ "delete # to delete a post." strcat 76 STRleft "|\r"
"|" cmdpfx @ "subscribe to get messages when new posts are made." strcat 76 STRleft "|\r"
"|" cmdpfx @ "unsubscribe to stop receiving messages when posts are made." strcat 76 STRleft "|\r"
"|" cmdpfx @ "mcheck to see unread messages on all boards you are subscribed to." strcat 76 STRleft "|\r"
"|" cmdpfx @ "help to get this message, or #help after any other command."  strcat 76 STRleft "|\r"
"+----------------------------------------------------------------------------+\r"
"|" "Administrator commands:" 76 STRcenter "|\r"
"+----------------------------------------------------------------------------+\r"
"|" cmdpfx @ "configure to configure board settings." strcat 76 STRleft "|\r"
"|" cmdpfx @ "ban user to ban a user from posting to the board." strcat 76 STRleft "|\r"
"|" cmdpfx @ "unban user to unban a user from posting to the board." strcat 76 STRleft "|\r"
"|" cmdpfx @ "allow user to add a user to the posting whitelist." strcat 76 STRleft "|\r"
"|" cmdpfx @ "disallow user to remove a user from the posting whitelist." strcat 76 STRleft "|\r"
"|" cmdpfx @ "protect to keep a post by being affected by message expiration." strcat 76 STRleft "|\r"
"|" cmdpfx @ "unprotect to make a post vulnerable to message expiration." strcat 76 STRleft "|\r"
"+----------------------------------------------------------------------------+\r"
"|" "How to set up your own board:" 76 STRcenter "|\r"
"|" "Create or select an object to be your bulletin board. For example," 76 STRcenter "|\r"
"|" "@create CorkBoard" 76 STRcenter "|\r"
"|" "Then create an action named 'setup-board', attach it to the board, and" 76 STRcenter "|\r"
"|" "link it to this program like so:" 76 STRcenter "|\r"
"|" "@act setup-board=CorkBoard" 76 STRcenter "|\r"
"|" "@link setup-board=" prog ifnstring "#" swap strcat strcat 76 STRcenter "|\r"
"|" "Then type 'setup-board'." 76 STRcenter "|\r"
"+----------------------------------------------------------------------------+\r" }cat .tell
;
 
: selection
trig name dup "read" instring 1 - strcut pop ";" instring if
     "Read command must be the first command alias. Aborting." .tell exit
then
mainarg @ "#h*" smatch if do-help exit then
command @ case
     "unread" instring when unread exit end
     "read" instring when 
          mainarg @ not if
               lister exit
          else
               mainarg @ "-" strcmp not if
                    1 readnextunread ! reader
               else
                    reader exit
               then
          then
     end
     "write" instring when makepost exit end
     "edit" instring when editpost exit end
     "catchup" instring when catch-up exit end
     "unban" instring when unbanuser exit end
     "ban" instring when banuser exit end
     "disallow" instring when disallowuser exit end
     "allow" instring when allowuser exit end
     "delete" instring when deletepost exit end
     "erase" instring when deletepost exit end
     "unsubscribe" instring when unsubscribe exit end
     "subscribe" instring when subscribe exit end
     "mcheck" instring when 1 mcheck ! connectannounce exit end
     "unprotect" instring when unprotect exit end
     "protect" instring when protect exit end
     "configure" instring when configure exit end
     "help" instring when do-help exit end
     default "Unknown command." .tell exit end
endcase
;
 
: main ( s -- )
me @ player? not if
     "This command for players only." .tell exit
then
command @ "Queued event." strcmp not if pop connectannounce exit then
mainarg !
command @ "convert-board" stringcmp not if
     convert-mesgboard exit
then
command @ "setup-board" stringcmp not if
     set-up exit
then
board ok? not if
     "That board does not exist." .tell exit
then
board dir "trigger" strcat getprop not if
     "You must name this action 'setup-board' and run it to make a board." .tell exit
then
board dir "configured?" strcat getprop not if
     "Board not yet configured. Entering configuration." .tell configure exit
then
board dir "trigger" strcat getpropstr stod trigger @ dbcmp not if
    { "This action is not registered with this board. If you want to use the same board object, '@set " trigger @ location name "=_board/dir:newprefix', where newprefix is a unique prefix for a new board." }cat .tell exit
then
clean-up
selection
"Done." .tell
;
 
public make-CorkBoard-post
public get-CorkBoard-PostID
public get-CorkBoard-post
public get-all-CorkBoard-posts
public del-CorkBoard-post
public protect-CorkBoard-post
public unprotect-CorkBoard-post
$libdef make-CorkBoard-post
$libdef get-CorkBoard-PostID
$libdef get-CorkBoard-post
$libdef get-all-CorkBoard-posts
$libdef del-CorkBoard-post
$libdef protect-CorkBoard-post
$libdef unprotect-CorkBoard-post
