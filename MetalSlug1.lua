#include<iostream>
#include"raylib.h"
const int ScreenHeight = 600;
const int ScreenWidth = 800;
const int Capacity = 1000;

struct Pos
{
	int r, c;
};

enum DIR
{
	Left, Right, Up, Down
};

struct Player
{
	Texture2D p_Texture;
	Pos c_position;
	DIR Direction;
};

struct Circle
{
	int rad;
	int r, c;
};

struct Bullet
{
	Texture2D texture;
	DIR Direction;
	Pos position;
	Circle C;
};

struct Plane
{
	Texture2D texture;
	Rectangle R_Collider;
	Pos p;
};

void init(Texture2D &bg1,Player& p,Bullet &b,Plane& Jahaz)
{
	bg1.width = ScreenWidth, bg1.height = ScreenHeight;
	DrawTexture(bg1, 0, 0, WHITE);

	p.p_Texture = LoadTexture("player.png");
	p.Direction = Right;
	p.p_Texture.height = 150, p.p_Texture.width = 100;
	p.c_position.r = ScreenHeight - p.p_Texture.height,
		p.c_position.c = 100;

	b.texture = LoadTexture("bullet.png");

	Jahaz.texture = LoadTexture("plane.png");
	Jahaz.texture.width = 250, Jahaz.texture.height = 150;

	Jahaz.R_Collider.width = Jahaz.texture.width - 20;
	Jahaz.R_Collider.height = Jahaz.texture.height - 20;
	
	Jahaz.p.r = 0, Jahaz.p.c = 400;
	Jahaz.R_Collider.x = Jahaz.p.c - 10;
	Jahaz.R_Collider.y = Jahaz.p.r + 10;
	DrawTexture(Jahaz.texture, Jahaz.p.c, Jahaz.p.r, RAYWHITE);
}

void UpdatePlayer(Player& p)
{
	if (IsKeyDown(KEY_LEFT) and (p.c_position.c > 0))
	{
		p.c_position.c -= 5, p.Direction = Left;
		p.p_Texture = LoadTexture("player2.png");
		p.p_Texture.height = 150, p.p_Texture.width = 100;
	}
	if (IsKeyDown(KEY_RIGHT) and (p.c_position.c < ScreenWidth - p.p_Texture.width))
	{
		p.c_position.c += 5, p.Direction = Right;
		p.p_Texture = LoadTexture("player.png");;
		p.p_Texture.height = 150, p.p_Texture.width = 100;
	}
	if (IsKeyDown(KEY_UP) and (p.c_position.r > (ScreenHeight / 2)))
		p.c_position.r -= 5, p.Direction = Up;
	else if (p.c_position.r < (ScreenHeight - p.p_Texture.height))
		p.c_position.r += 5;
}

void Shoot(Player P, Bullet& b)
{
	/*if(IsKeyDown(KEY_X))
	{*/
		//Leave a missile that will continue moving till end coordinates
		if (P.Direction == Right)
		{
			b.texture = LoadTexture("bullet.png");
			b.texture.width = 60, b.texture.height = 40;
			b.position.c = P.c_position.c + P.p_Texture.width - 10;
			b.position.r = P.c_position.r + 30;
			b.Direction = Right;
		}
		else if (P.Direction == Left)
		{
			b.texture = LoadTexture("bulletleft.png");
			b.texture.width = 60, b.texture.height = 40;
			b.position.c = P.c_position.c - 1;
			b.position.r = P.c_position.r + 30;
			b.Direction = Left;
		}
		else if (P.Direction == Up)
		{
			b.texture = LoadTexture("bulletup.png");
			b.texture.width = 40, b.texture.height = 60;
			b.position.r = P.c_position.r - 8;
			b.position.c = P.c_position.c + 20;
			b.Direction = Up;
		}
		b.C.rad = 20;
		b.C.r = b.position.r, b.C.c = b.position.c;
		/*return true;
	}
	return false;*/
}

void Swap(Bullet& b, Bullet& b2)
{
	Bullet temp = b;
	b = b2;
	b2 = temp;
}

void deleteIndex(Bullet B[], int& size, int ind)
{
	for (int i = ind;i + 1 < size;i++)
	{
		Swap(B[i], B[i + 1]);
	}
	size--;
}


void UpdateBullet(Bullet b[],int &size)
{
	for(int i = 0;i < size;i++)
	{
		if (b[i].Direction == Right and b[i].position.c < (ScreenWidth - b[i].texture.width))
		{
			b[i].position.c += 10;
			DrawTexture(b[i].texture, b[i].position.c, b[i].position.r, RAYWHITE);
			b[i].C.rad = 20;
			b[i].C.r = b[i].position.r, b[i].C.c = b[i].position.c;
		}
		else if (b[i].Direction == Right and b[i].position.c >= (ScreenWidth - b[i].texture.width))
		{
			deleteIndex(b, size, i);
		}

		if (b[i].Direction == Left and b[i].position.c > 0)
		{
			b[i].position.c -= 10;
			DrawTexture(b[i].texture, b[i].position.c, b[i].position.r, RAYWHITE);
			b[i].C.rad = 20;
			b[i].C.r = b[i].position.r, b[i].C.c = b[i].position.c;
		}
		else if (b[i].Direction == Left and b[i].position.c <= 0)
		{
			deleteIndex(b, size, i);
		}

		if (b[i].Direction == Up and b[i].position.r > 0)
		{
			b[i].position.r -= 10;
			DrawTexture(b[i].texture, b[i].position.c, b[i].position.r, RAYWHITE);
			b[i].C.rad = 20;
			b[i].C.r = b[i].position.r, b[i].C.c = b[i].position.c;
		}
		else if (b[i].Direction == Up and b[i].position.r <= 0)
		{
			deleteIndex(b, size, i);
		}
	}
}

void bullettouchesPlane(Plane &Jahaz,Bullet bullet[],int size,int &count)
{
	Vector2 temp;
	for(int i = 0; i < size; i++)
	{
		temp.x = bullet[i].position.c;
		temp.y = bullet[i].position.r;

		if (CheckCollisionCircleRec(temp, (float)(bullet[i].C.rad), Jahaz.R_Collider))
		{
			count++;
			bullet[i].position.r = NULL, bullet[i].position.c = NULL;
			deleteIndex(bullet, size, i);
		}
	}
}

void UpdatePlane(Plane& Jahaz,int count)
{
	if (count < 100)
	{
		DrawTexture(Jahaz.texture, Jahaz.p.c, Jahaz.p.r, RAYWHITE);
	}
	if (count > 100)
	{
		Jahaz.R_Collider.width = 0, Jahaz.R_Collider.height = 0;
	}
}

int main()
{
	SetTargetFPS(90);
	InitWindow(ScreenWidth, ScreenHeight, "Metal Slug");
	Texture2D bg1 = LoadTexture("bg1.png");
	Player p;
	Bullet b[Capacity]{};
	Plane Jahaz;
	int i = 0, count = 0;
	init(bg1, p, b[i], Jahaz);
	while (true)
	{
		BeginDrawing();
		ClearBackground(RAYWHITE);
		DrawTexture(bg1, 0, 0, WHITE);
		DrawTexture(p.p_Texture, p.c_position.c, p.c_position.r, RAYWHITE);
		bullettouchesPlane(Jahaz, b, i, count);
		UpdatePlane(Jahaz, count);
		UpdatePlayer(p);
		if (IsKeyDown(KEY_X))
			Shoot(p, b[i]),i++;
		UpdateBullet(b, i);
		
		EndDrawing();
	}
	return 0;
}

//When Plane comes again
//Fix textures width and height again
