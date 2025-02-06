#include<iostream>
#include"raylib.h"
#include<ctime>
const int ScreenHeight = 600;
const int ScreenWidth = 800;
const int Capacity = 1000;
const int NoOfEnemies = 3;

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
	Rectangle Collider;
};
struct Enemy
{
	Texture2D ETexture;
	Pos Eposition;
	int speed;
	Rectangle ColliderE;
};


struct Circle
{
	int rad;
	float r, c;
};

struct Missile
{
	Texture2D texture;
	DIR Direction;
	Pos position;
	Rectangle Collider;
};

struct Bullet
{
	Texture2D texture;
	DIR Direction;
	Pos position;
	Circle C;
};

struct BOMB
{
	Texture2D texture;
	Circle C;
	int c;
	float r;
};

struct Plane
{
	Texture2D texture;
	Rectangle R_Collider;
	Pos p;
};

struct Background
{
	Texture2D bg;
	Pos position;
};

void initPlayer(Player& p)
{
	p.p_Texture = LoadTexture("player.png");
	p.Direction = Right;
	p.p_Texture.height = 150, p.p_Texture.width = 100;
	p.c_position.r = ScreenHeight - p.p_Texture.height,
		p.c_position.c = 100;
	p.Collider.height = p.p_Texture.height - 10;
	p.Collider.width = p.p_Texture.width - 10;
	p.Collider.x = p.c_position.c + 5;
	p.Collider.y = p.c_position.r + 5;
}

void initEnemy(Enemy e[])
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		e[i].ETexture = LoadTexture("Enemy.png");
		e[i].ETexture.height = 150, e[i].ETexture.width = 100;
		e[i].Eposition.r = ScreenHeight - e[i].ETexture.height;
		e[i].Eposition.c = ScreenWidth + (i * 50) + 400;
		e[i].speed = 1;
		e[i].ColliderE.x = e[i].Eposition.c + 10;
		e[i].ColliderE.y = e[i].Eposition.r + 20;
		e[i].ColliderE.width = e[i].ETexture.width - 20;
		e[i].ColliderE.height = e[i].ETexture.height - 40;
	}
}

void init(Background& bg1, Player& p, Bullet& b, Plane& Jahaz, Background& bg2, Enemy e[])
{
	bg1.bg.width = ScreenWidth, bg1.bg.height = ScreenHeight;
	bg2.bg.width = ScreenWidth, bg2.bg.height = ScreenHeight;
	bg1.position.r = 0, bg1.position.c = 0;
	bg2.position.r = 0, bg2.position.c = ScreenWidth;

	DrawTexture(bg1.bg, bg1.position.c, bg1.position.r, WHITE);
	DrawTexture(bg2.bg, bg2.position.c, bg2.position.r, RAYWHITE);

	initPlayer(p);

	b.texture = LoadTexture("bullet.png");

	Jahaz.texture = LoadTexture("plane.png");
	Jahaz.texture.width = 250, Jahaz.texture.height = 150;

	Jahaz.R_Collider.width = Jahaz.texture.width - 20;
	Jahaz.R_Collider.height = Jahaz.texture.height - 20;

	Jahaz.p.r = 0, Jahaz.p.c = 400;
	Jahaz.R_Collider.x = Jahaz.p.c - 10;
	Jahaz.R_Collider.y = Jahaz.p.r + 10;
	DrawTexture(Jahaz.texture, Jahaz.p.c, Jahaz.p.r, RAYWHITE);

	initEnemy(e);
}

void UpdatePlayer(Player& p)
{
	if (IsKeyDown(KEY_LEFT) and (p.c_position.c > 0))
	{
		p.c_position.c -= 5, p.Direction = Left;
		p.Collider.x -= 5;
		p.p_Texture = LoadTexture("player2.png");
		p.p_Texture.height = 150, p.p_Texture.width = 100;
	}
	if (IsKeyDown(KEY_RIGHT) and (p.c_position.c < ScreenWidth - p.p_Texture.width))
	{
		p.c_position.c += 5, p.Direction = Right;
		p.p_Texture = LoadTexture("player.png");
		p.Collider.x += 5;
		p.p_Texture.height = 150, p.p_Texture.width = 100;
	}
	if (IsKeyDown(KEY_UP) and (p.c_position.r > (ScreenHeight / 2)))
		p.c_position.r -= 5, p.Direction = Up, p.Collider.y -= 5;
	else if (p.c_position.r < (ScreenHeight - p.p_Texture.height))
		p.c_position.r += 5, p.Collider.y += 5;
}
void DrawEnemy(Enemy e[])
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		DrawTexture(e[i].ETexture, e[i].Eposition.c, e[i].Eposition.r, RAYWHITE);
	}
}
void MoveEnemy(Enemy e[])
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		e[i].Eposition.c -= e[i].speed;
		if (e[i].Eposition.c < -ScreenWidth)
		{
			e[i].Eposition.c = ScreenWidth - e[i].ETexture.width - 10;
			e[i].Eposition.r = ScreenHeight - e[i].ETexture.height - 10;
		}
		e[i].ColliderE.x = e[i].Eposition.c + 10;
		e[i].ColliderE.y = e[i].Eposition.r + 20;
		e[i].ColliderE.width = e[i].ETexture.width - 20;
		e[i].ColliderE.height = e[i].ETexture.height - 40;
	}
}

bool EnemyKilled(Enemy e, Bullet bullet[], int size)
{
	Vector2 temp;
	for (int i = 0;i < size;i++)
	{
		temp.x = bullet[i].position.c;
		temp.y = bullet[i].position.r;

		if (CheckCollisionCircleRec(temp, (float)(bullet[i].C.rad), e.ColliderE))
		{
			return true;
		}
	}
	return false;
}

void DelEnemy(Enemy& e,int i)
{
	e.Eposition.c = ScreenWidth + (i * 50) + 400;
	e.ColliderE.width = 0;
	e.ColliderE.height = 0;
}

void Shoot(Player P, Bullet& b)
{
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

void SwapMissile(Missile& b, Missile& b2)
{
	Missile temp = b;
	b = b2;
	b2 = temp;
}

void deleteIndexMissile(Missile B[], int& size, int ind)
{
	for (int i = ind;i + 1 < size;i++)
	{
		SwapMissile(B[i], B[i + 1]);
	}
	size--;
}

void UpdateBullet(Bullet b[], int& size)
{
	for (int i = 0;i < size;i++)
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
void SwapEnemy(Enemy& e, Enemy& e2)
{
	Enemy temp = e;
	e = e2;
	e2 = temp;
}

bool EnemytouchesPlayer(Enemy e[], Player p)
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		if (CheckCollisionRecs(e[i].ColliderE, p.Collider))
		{
			return true;
		}
	}
	return false;
}

void UpdatePlane(Plane& Jahaz, int count)
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

void BombardMissiles(Missile Missiles[], int& size, Plane Jahaz)
{
	srand(time(0));
	Missiles[size].texture = LoadTexture("missiles.png");
	Missiles[size].Direction = Down;

	Missiles[size].position.c = (rand() % (Jahaz.texture.width - Jahaz.p.c)) + Jahaz.p.c;
	Missiles[size].position.r = Jahaz.p.r + Jahaz.texture.height;

	Missiles[size].texture.width = 50, Missiles[size].texture.height = 100;
	DrawTexture(Missiles[size].texture, Missiles[size].position.c, Missiles[size].position.r, RAYWHITE);

	Missiles[size].Collider.width = Missiles[size].texture.width - 20;
	Missiles[size].Collider.height = Missiles[size].texture.height - 40;
	Missiles[size].Collider.x = Missiles[size].position.c + 10;
	Missiles[size].Collider.y = Missiles[size].position.r + 10;

	size++;
}

void UpdateMissiles(Missile Missiles[], int& size, Plane Jahaz)
{
	for (int i = 0;i < size;i++)
	{
		Missiles[i].position.r += 3;
		Missiles[i].Collider.y += 3;
		DrawTexture(Missiles[i].texture, Missiles[i].position.c, Missiles[i].position.r, RAYWHITE);
		if (Missiles[i].position.r >= ScreenHeight)
			deleteIndexMissile(Missiles, size, i);
	}
}

void MovingBackground(Background& bg1, Background& bg2)
{
	if (bg1.position.c == -ScreenWidth)
		bg1.position.c = ScreenWidth;
	DrawTexture(bg1.bg, bg1.position.c, bg1.position.r, WHITE);
	bg1.position.c--;

	if (bg2.position.c == -ScreenWidth)
		bg2.position.c = ScreenWidth;
	DrawTexture(bg2.bg, bg2.position.c, bg2.position.r, WHITE);
	bg2.position.c--;
}

bool PlaneDestroyed(Plane& Jahaz, Bullet bullet[], int& size, int& count,int& score)
{
	Vector2 temp;
	for (int i = 0;i < size;i++)
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
	if (count >= 100)
	{
		if (Jahaz.p.c < ScreenWidth)
			Jahaz.p.c += 10, Jahaz.p.r += 5, DrawTexture(Jahaz.texture, Jahaz.p.c, Jahaz.p.r, RAYWHITE);
		return true;
	}
	return false;
}

void ReSpawnPlane(Plane& Jahaz)
{
	Jahaz.texture = LoadTexture("plane.png");
	Jahaz.texture.width = 250, Jahaz.texture.height = 150;

	Jahaz.R_Collider.width = Jahaz.texture.width - 20;
	Jahaz.R_Collider.height = Jahaz.texture.height - 20;

	Jahaz.p.r = 0, Jahaz.p.c = 400;
	Jahaz.R_Collider.x = Jahaz.p.c - 10;
	Jahaz.R_Collider.y = Jahaz.p.r + 10;
	DrawTexture(Jahaz.texture, Jahaz.p.c, Jahaz.p.r, RAYWHITE);
}

bool MissileTouchesPlayer(Missile Missiles[], int& size, Plane Jahaz, Player p)
{
	for (int i = 0;i < size;i++)
	{
		if (CheckCollisionRecs(Missiles[i].Collider, p.Collider))
		{
			deleteIndexMissile(Missiles, size, i);
			return true;
		}
	}
	return false;
}

void BulletTouchesEnemy(Enemy e[], Bullet b[], int &size,int &score)
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		if (EnemyKilled(e[i], b, size))
		{
			DelEnemy(e[i], i);
			deleteIndex(b, size, i);
			score += 100;
		}
	}
}

void UpdateBomb(BOMB bomb[])
{
	for(int i=0;i<NoOfEnemies;i++)
	{
		bomb[i].r += 0.5;
		bomb[i].c -= 2;
		bomb[i].C.r += 0.5;
		bomb[i].C.c -= 2;
		DrawTexture(bomb[i].texture, bomb[i].c, bomb[i].r, RAYWHITE);
	}
}

void initbomb(Enemy e[], BOMB bomb[])
{
	for(int i=0;i<NoOfEnemies;i++)
	{
		bomb[i].texture = LoadTexture("bomb.png");
		bomb[i].texture.width = 60;
		bomb[i].texture.height = 60;
		bomb[i].r = e[i].Eposition.r - 10;
		bomb[i].c = e[i].Eposition.c;
		DrawTexture(bomb[i].texture, bomb[i].c, bomb[i].r, RAYWHITE);
		bomb[i].C.rad = bomb[i].texture.height / 2 - 10;
		bomb[i].C.r = bomb[i].r + 5;
		bomb[i].C.c = bomb[i].c + 5;
	}
}

void BombDestroy(BOMB bomb[],Enemy e[])
{
	for(int i=0;i<NoOfEnemies;i++)
	{
		if (bomb[i].r >= ScreenHeight)
		{
			initbomb(e, bomb);
		}
	}
}

bool BombtouchesPlayer(Player P,BOMB bomb[])
{
	Vector2 temp;
	for (int i = 0;i < NoOfEnemies;i++)
	{
		temp.x = bomb[i].c;
		temp.y = bomb[i].r;
		if (CheckCollisionCircleRec(temp, (float)(bomb[i].C.rad), P.Collider))
		{
			return true;
		}
	}
	return false;
}

int main()
{
	SetTargetFPS(90);
	InitWindow(ScreenWidth, ScreenHeight, "Metal Slug");
	Background bg1;
	bg1.bg = LoadTexture("bg1.png");
	Background bg2;
	bg2.bg = LoadTexture("bg2.png");
	Player p;
	Bullet b[Capacity]{};
	BOMB bomb[NoOfEnemies];
	Missile Missiles[Capacity];
	Enemy e[NoOfEnemies] = { };
	Plane Jahaz;
	time_t CT = time(0);
	time_t PRS = time(0);
	time_t temptime;
	int i = 0, count = 0, Msize = 0, score = 0;
	int elapsed = 0, PReSpawn = 0, temp = 0, lives = 3;
	init(bg1, p, b[i], Jahaz, bg2, e);
	initbomb(e, bomb);
	while (lives > 0)
	{
		if (GetKeyPressed() == KEY_ESCAPE)
		{
			break;
		}
		BeginDrawing();
		ClearBackground(RAYWHITE);
		MovingBackground(bg1, bg2);
		MoveEnemy(e);
		DrawEnemy(e);
		DrawText(TextFormat("LIVES = %d", lives), 10, 10, 30, RAYWHITE);
		DrawText(TextFormat("SCORE = %d", score), 10, 45, 30, RAYWHITE);

		DrawTexture(p.p_Texture, p.c_position.c, p.c_position.r, RAYWHITE);

		time_t NT = time(0);
		elapsed = NT - CT;
		if (!PlaneDestroyed(Jahaz, b, i, count, score) and elapsed > 1)
		{
			BombardMissiles(Missiles, Msize, Jahaz);
			elapsed = 0;
			CT = time(0);
		}
		NT = time(0);
		PReSpawn = NT - PRS;
		if (count > 100 and (PReSpawn >= 20))
		{
			score += 1000;
			ReSpawnPlane(Jahaz);
			count = 0;
			PRS = time(0);
			PReSpawn = 0;
		}
		if (BombtouchesPlayer(p, bomb))
		{
			initPlayer(p);
			initEnemy(e);
			initbomb(e, bomb);
			lives--;
		}
		UpdatePlane(Jahaz, count);
		UpdatePlayer(p);
		UpdateBomb(bomb);
		BulletTouchesEnemy(e, b, i,score);
		BombDestroy(bomb, e);
		
		if (EnemytouchesPlayer(e, p))
		{
			lives--;
			initPlayer(p);
			initEnemy(e);
		}
		UpdateMissiles(Missiles, Msize, Jahaz);
		if (MissileTouchesPlayer(Missiles, Msize, Jahaz, p))
		{
			lives--;
			initPlayer(p);
		}
		if (IsKeyDown(KEY_X))
			Shoot(p, b[i]), i++;
		UpdateBullet(b, i);
		EndDrawing();
		if (score >= 5000)
			break;
	}

	if (score >= 5000)
	{
		while (true)
		{

			if (GetKeyPressed() == KEY_ESCAPE)
			{
				break;
			}
			BeginDrawing();
			ClearBackground(BLACK);
			DrawText("LEVEL 1 CLEARED", 90, 250, 75, RAYWHITE), CT = time(0);
			EndDrawing();
		}
	}
	else
	{
		while (true)
		{
			if (GetKeyPressed() == KEY_ESCAPE)
			{
				break;
			}
			BeginDrawing();
			ClearBackground(BLACK);
			DrawText("GAME OVER", 100, 250, 100, RAYWHITE), CT = time(0);
			EndDrawing();
		}
	}

	return 0;
}