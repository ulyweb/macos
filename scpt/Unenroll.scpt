FasdUAS 1.101.10   ��   ��    k             l     ��  ��    - ' Prompt for admin username and password     � 	 	 N   P r o m p t   f o r   a d m i n   u s e r n a m e   a n d   p a s s w o r d   
  
 l     ����  r         n     	    1    	��
�� 
ttxt  l     ����  I    ��  
�� .sysodlogaskr        TEXT  m        �   * E n t e r   A d m i n   U s e r n a m e :  �� ��
�� 
dtxt  m       �    ��  ��  ��    o      ���� 0 adminusername adminUsername��  ��        l    ����  r        n        1    ��
�� 
ttxt  l     ����   I   �� ! "
�� .sysodlogaskr        TEXT ! m     # # � $ $ * E n t e r   A d m i n   P a s s w o r d : " �� % &
�� 
dtxt % m     ' ' � ( (   & �� )��
�� 
htxt ) m    ��
�� boovtrue��  ��  ��    o      ���� 0 adminpassword adminPassword��  ��     * + * l     ��������  ��  ��   +  , - , l     �� . /��   . $  Display a confirmation dialog    / � 0 0 <   D i s p l a y   a   c o n f i r m a t i o n   d i a l o g -  1 2 1 l   8 3���� 3 r    8 4 5 4 n    4 6 7 6 1   0 4��
�� 
bhit 7 l   0 8���� 8 I   0�� 9 :
�� .sysodlogaskr        TEXT 9 m     ; ; � < < X A r e   y o u   s u r e   y o u   w a n t   t o   u n e n r o l l   f r o m   J a m f ? : �� = >
�� 
btns = J      ? ?  @ A @ m     B B � C C  C a n c e l A  D�� D m     E E � F F  U n e n r o l l��   > �� G H
�� 
dflt G m   ! $ I I � J J  C a n c e l H �� K��
�� 
appr K m   ' * L L � M M  U n e n r o l l   J a m f��  ��  ��   5 o      ���� 0 confirmation  ��  ��   2  N O N l     ��������  ��  ��   O  P Q P l     �� R S��   R 6 0 If the user confirms, proceed with unenrollment    S � T T `   I f   t h e   u s e r   c o n f i r m s ,   p r o c e e d   w i t h   u n e n r o l l m e n t Q  U�� U l  9 � V���� V Z   9 � W X�� Y W =  9 @ Z [ Z o   9 <���� 0 confirmation   [ m   < ? \ \ � ] ]  U n e n r o l l X k   C � ^ ^  _ ` _ l  C C��������  ��  ��   `  a b a l  C C�� c d��   c / ) Define the full path to the jamf command    d � e e R   D e f i n e   t h e   f u l l   p a t h   t o   t h e   j a m f   c o m m a n d b  f g f r   C J h i h m   C F j j � k k ( / u s r / l o c a l / j a m f / b i n / i o      ���� 0 jamfpath jamfPath g  l m l l  K K��������  ��  ��   m  n o n l  K K�� p q��   p 0 * Define the commands to unenroll from Jamf    q � r r T   D e f i n e   t h e   c o m m a n d s   t o   u n e n r o l l   f r o m   J a m f o  s t s r   K Z u v u b   K V w x w b   K R y z y m   K N { { � | | 
 s u d o   z o   N Q���� 0 jamfpath jamfPath x m   R U } } � ~ ~ "   R e m o v e M D M P r o f i l e v o      ���� 20 removemdmprofilecommand removeMDMProfileCommand t   �  r   [ j � � � b   [ f � � � b   [ b � � � m   [ ^ � � � � � 
 s u d o   � o   ^ a���� 0 jamfpath jamfPath � m   b e � � � � �     r e m o v e F r a m e w o r k � o      ���� 00 removeframeworkcommand removeFrameworkCommand �  � � � l  k k��������  ��  ��   �  � � � l  k k�� � ���   � - ' Run the commands with admin privileges    � � � � N   R u n   t h e   c o m m a n d s   w i t h   a d m i n   p r i v i l e g e s �  � � � I  k z�� � �
�� .sysoexecTEXT���     TEXT � o   k n���� 20 removemdmprofilecommand removeMDMProfileCommand � �� � �
�� 
RApw � o   q r���� 0 adminpassword adminPassword � �� ���
�� 
badm � m   u v��
�� boovtrue��   �  � � � I  { ��� � �
�� .sysoexecTEXT���     TEXT � o   { ~���� 00 removeframeworkcommand removeFrameworkCommand � �� � �
�� 
RApw � o   � ����� 0 adminpassword adminPassword � �� ���
�� 
badm � m   � ���
�� boovtrue��   �  � � � l  � ���������  ��  ��   �  � � � l  � ��� � ���   � 4 . Notify the user that unenrollment is complete    � � � � \   N o t i f y   t h e   u s e r   t h a t   u n e n r o l l m e n t   i s   c o m p l e t e �  ��� � I  � ��� � �
�� .sysodlogaskr        TEXT � m   � � � � � � � 8 J a m f   u n e n r o l l m e n t   c o m p l e t e d . � �� � �
�� 
btns � J   � � � �  ��� � m   � � � � � � �  O K��   � �� � �
�� 
dflt � m   � � � � � � �  O K � �� ���
�� 
appr � m   � � � � � � �  U n e n r o l l   J a m f��  ��  ��   Y k   � � � �  � � � l  � ��� � ���   � "  User canceled the operation    � � � � 8   U s e r   c a n c e l e d   t h e   o p e r a t i o n �  ��� � I  � ��� � �
�� .sysodlogaskr        TEXT � m   � � � � � � � 6 J a m f   u n e n r o l l m e n t   c a n c e l e d . � �� � �
�� 
btns � J   � � � �  ��� � m   � � � � � � �  O K��   � �� � �
�� 
dflt � m   � � � � � � �  O K � �� ���
�� 
appr � m   � � � � � � �  U n e n r o l l   J a m f��  ��  ��  ��  ��       
�� � � � � � j � �����   � ����������������
�� .aevtoappnull  �   � ****�� 0 adminusername adminUsername�� 0 adminpassword adminPassword�� 0 confirmation  �� 0 jamfpath jamfPath�� 20 removemdmprofilecommand removeMDMProfileCommand�� 00 removeframeworkcommand removeFrameworkCommand��   � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �  
 � �   � �  1 � �  U����  ��  ��   �   � * �� ������ # '������ ;�� B E�� I�� L������ \ j�� { }�� � �����~�} � � � � � � � �
�� 
dtxt
�� .sysodlogaskr        TEXT
�� 
ttxt�� 0 adminusername adminUsername
�� 
htxt�� �� 0 adminpassword adminPassword
�� 
btns
�� 
dflt
�� 
appr�� 
�� 
bhit�� 0 confirmation  �� 0 jamfpath jamfPath�� 20 removemdmprofilecommand removeMDMProfileCommand�� 00 removeframeworkcommand removeFrameworkCommand
� 
RApw
�~ 
badm
�} .sysoexecTEXT���     TEXT�� ����l �,E�O����e� �,E�O����lv�a a a a  a ,E` O_ a   fa E` Oa _ %a %E` Oa _ %a %E` O_ a �a  e� !O_ a �a  e� !Oa "�a #kv�a $a a %a  Y a &�a 'kv�a (a a )a   � � � �  u f r a n c i s c o � � � � $ 4 0 8 7 0 7 4 0 6 6 H I D E $ $ m e � � � �  U n e n r o l l � � � � T s u d o   / u s r / l o c a l / j a m f / b i n /   R e m o v e M D M P r o f i l e � � � � R s u d o   / u s r / l o c a l / j a m f / b i n /   r e m o v e F r a m e w o r k��   ascr  ��ޭ