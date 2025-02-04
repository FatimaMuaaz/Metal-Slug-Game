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

void init(Texture2D &bg1,Player& p)
{
	bg1.width = ScreenWidth, bg1.height = ScreenHeight;
	DrawTexture(bg1, 0, 0, WHITE);

	p.p_Texture = LoadTexture("player.png");
	p.p_Texture.height = 150, p.p_Texture.width = 100;
	p.c_position.r = ScreenHeight - p.p_Texture.height,
		p.c_position.c = 100;
}

void UpdatePlayer(Player& p)
{
	if (IsKeyDown(KEY_LEFT))
		p.c_position.c-=10;
	if (IsKeyDown(KEY_RIGHT))
		p.c_position.c+=10;
	if (IsKeyDown(KEY_UP))
		p.c_position.r-=10;
	else if (p.c_position.r < (ScreenHeight - p.p_Texture.height))
		p.c_position.r+=10;
}

int main()
{
	SetTargetFPS(120);
	InitWindow(ScreenWidth, ScreenHeight, "Metal Slug");
	Texture2D bg1 = LoadTexture("bg1.png");
	Player p;
	init(bg1, p);
	while (true)
	{
		BeginDrawing();
		ClearBackground(RAYWHITE);
		DrawTexture(bg1, 0, 0, WHITE);
		DrawTexture(p.p_Texture, p.c_position.c, p.c_position.r, RAYWHITE);
		UpdatePlayer(p);
		EndDrawing();
	}
	return 0;
}