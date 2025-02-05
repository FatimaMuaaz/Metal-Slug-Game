#include<iostream>
#include"raylib.h"
const int ScreenHeight = 600;
const int ScreenWidth = 800;

struct Pos
{
	int r, c;
};

struct Player
{
	Texture2D p_Texture;
	Pos c_position;
};
struct Enemy
{
	Texture2D ETexture;
	Pos Eposition;
	int speed;

};
struct Bomb
{
	Texture2D BTexture;
	Pos Bposition;
	int speed;
};




void init(Texture2D& bg1, Player& p, Enemy& e,Bomb &b)
{
	bg1.width = ScreenWidth, bg1.height = ScreenHeight;
	DrawTexture(bg1, 0, 0, WHITE);

	p.p_Texture = LoadTexture("player.png");
	p.p_Texture.height = 150, p.p_Texture.width = 100;
	p.c_position.r = ScreenHeight - p.p_Texture.height,
		p.c_position.c = 100;
	e.ETexture = LoadTexture("Enemy.png");
	e.ETexture.height = 150, e.ETexture.width = 100;
	e.Eposition.r = ScreenWidth - e.ETexture.width - 10;
	e.Eposition.c = ScreenHeight - e.ETexture.width - 10;
	e.speed = 2;
	//b.BTexture = LoadTexture("bomb.png");
	//b.BTexture.height = 70, b.BTexture.width = 50;
	//b.Bposition.r = ScreenWidth - b.BTexture.width - 10;
	//b.Bposition.c = ScreenHeight - b.BTexture.width - 10;
	//b.speed = 2;
}


void UpdatePlayer(Player& p)
{
	if (IsKeyDown(KEY_LEFT))
		p.c_position.c -= 10;
	if (IsKeyDown(KEY_RIGHT))
		p.c_position.c += 10;
	if (IsKeyDown(KEY_UP))
		p.c_position.r -= 10;
	else if (p.c_position.r < (ScreenHeight - p.p_Texture.height))
		p.c_position.r += 10;
}
void MoveEnemy(Enemy &e)
{
	e.Eposition.c -= e.speed;


	
	if (e.Eposition.c < -ScreenWidth) 
	{
		e.Eposition.c = ScreenWidth -e.ETexture.width - 10;
		e.Eposition.r = ScreenHeight - e.ETexture.height - 10; 
	}
       
		
}
void MoveBomb(Bomb& b)
{
	//b.Bposition.c -= b.speed;



	//if (b.Bposition.c < -ScreenWidth)
	{
		//b.Bposition.c = ScreenWidth - b.BTexture.width - 10;
		//b.Bposition.r = ScreenHeight - b.BTexture.height - 10;
	}


}




int main()
{
	SetTargetFPS(90);
	InitWindow(ScreenWidth, ScreenHeight, "Metal Slug");
	Texture2D bg1 = LoadTexture("bg1.png");
	Player p;
	Enemy e;
	Bomb b;
	init(bg1, p,e,b);
	
	
	
	while (true)
	{
		if (GetKeyPressed() == KEY_ESCAPE)
		{
			break;
		}
		BeginDrawing();
		ClearBackground(RAYWHITE);
		DrawTexture(bg1, 0, 0, WHITE);
		DrawTexture(p.p_Texture, p.c_position.c, p.c_position.r, RAYWHITE);
		UpdatePlayer(p);
		DrawTexture(e.ETexture, e.Eposition.c, e.Eposition.r, RAYWHITE);
		MoveEnemy(e);
		//DrawTexture(b.BTexture, b.Bposition.c, b.Bposition.r, RAYWHITE);
		//MoveBomb(b);
		EndDrawing();
	}
	return 0;
}