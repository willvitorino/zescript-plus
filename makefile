all : zesc_p.l zesc_p.y
	flex -i zesc_p.l
	bison zesc_p.y
	gcc zesc_p.tab.c -lfl -lm
	clear
	./a.out
