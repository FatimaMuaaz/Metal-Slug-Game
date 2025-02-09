//https://github.com/FatimaMuaaz/Metal-Slug-Game
#include<iostream>
#include"raylib.h"
#include<ctime>
const int ScreenHeight = 600;
const int ScreenWidth = 800;
const int Capacity = 1000;
const int NoOfEnemies = 3;

int score = 0;
int lives = 3;

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
	void (*fptr)(Player&);
};

struct Enemy
{
	Texture2D ETexture;
	Pos Eposition;
	int speed;
	Rectangle ColliderE;
	void(*fptr)(Enemy&, int);

};

struct Alley
{
	Pos PositionA;
	Rectangle Collider;
	int speedA;
	Texture2D textureA;
};

struct Circle
{
	int rad;
	float r, c;
};

struct Bullet
{
	Texture2D texture;
	DIR Direction;
	Pos position;
	Circle C;
	Rectangle Collider;
	int c;
	float r;
	void(*fptr)(Bullet[], int&);
};

struct Background
{
	Texture2D bg;
	Pos position;
};
struct GameSounds
{
	Sound Gunshots;
	Sound Helicopter;
	Sound End;
	Music background;
	Music Victory;
	Sound Over;
	Sound PlaneCrash;
};

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

void UpdateTank(Player& p)
{
	if (IsKeyDown(KEY_LEFT) and (p.c_position.c > 0))
	{
		p.c_position.c -= 5, p.Direction = Left;
		p.Collider.x -= 5;
		p.p_Texture = LoadTexture("Tank2.png");
		p.p_Texture.height = 100, p.p_Texture.width = 150;
		p.fptr = UpdateTank;
	}
	if (IsKeyDown(KEY_RIGHT) and (p.c_position.c < ScreenWidth - p.p_Texture.width))
	{
		p.c_position.c += 5, p.Direction = Right;
		p.p_Texture = LoadTexture("Tank.png");
		p.Collider.x += 5;
		p.p_Texture.height = 100, p.p_Texture.width = 150;
		p.fptr = UpdateTank;
	}

	if (IsKeyDown(KEY_UP) and (p.c_position.r > (ScreenHeight / 2)))
		p.Direction = Up;
}

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
	p.fptr = UpdatePlayer;
}

void MoveEnemy(Enemy& e, int count)  //init mein for loop lagani enrmy ki
{
	e.Eposition.c -= e.speed;
	if (e.Eposition.c < -ScreenWidth)
	{
		e.Eposition.c = ScreenWidth - e.ETexture.width - 10;
		e.Eposition.r = ScreenHeight - e.ETexture.height - 10;
	}
	e.ColliderE.x = e.Eposition.c + 10;
	e.ColliderE.y = e.Eposition.r + 20;
	e.ColliderE.width = e.ETexture.width - 20;
	e.ColliderE.height = e.ETexture.height - 40;
	e.fptr = MoveEnemy;
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
		e[i].fptr = MoveEnemy;
	}
}

void InitAlly(Alley& a, bool& AllyGotShot)
{
	a.textureA = LoadTexture("friend.png");

	a.textureA.height = 150, a.textureA.width = 100;
	a.PositionA.r = ScreenHeight - a.textureA.height,
		a.PositionA.c = ScreenWidth + 100;
	a.Collider.height = a.textureA.height - 10;
	a.Collider.width = a.textureA.width - 10;
	a.Collider.x = a.PositionA.c + 5;
	a.Collider.y = a.PositionA.r + 5;
	AllyGotShot = false;
}

void UpdatePlane(Enemy& Jahaz, int count)
{
	if (count < 100)
	{
		Jahaz.ETexture = LoadTexture("plane.png");
		Jahaz.ETexture.width = 250, Jahaz.ETexture.height = 150;

		Jahaz.ColliderE.width = Jahaz.ETexture.width - 20;
		Jahaz.ColliderE.height = Jahaz.ETexture.height - 20;

		Jahaz.Eposition.r = 0, Jahaz.Eposition.c = 400;
		Jahaz.ColliderE.x = Jahaz.Eposition.c - 10;
		Jahaz.ColliderE.y = Jahaz.Eposition.r + 10;
		DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
		Jahaz.fptr = nullptr;
	}
	if (count > 100)
	{
		Jahaz.ColliderE.width = 0, Jahaz.ColliderE.height = 0;
	}
}

void UpdatePlane2(Enemy& Jahaz, int count)
{
	if (count < 100)
	{
		Jahaz.ETexture = LoadTexture("plane.png");
		Jahaz.ETexture.width = 250, Jahaz.ETexture.height = 150;

		Jahaz.ColliderE.width = Jahaz.ETexture.width - 20;
		Jahaz.ColliderE.height = Jahaz.ETexture.height - 20;

		Jahaz.Eposition.r = 0, Jahaz.Eposition.c = 395;
		Jahaz.ColliderE.x = Jahaz.Eposition.c - 10;
		Jahaz.ColliderE.y = Jahaz.Eposition.r + 10;
		DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
		Jahaz.fptr = UpdatePlane;
	}
	if (count > 100)
	{
		Jahaz.ColliderE.width = 0, Jahaz.ColliderE.height = 0;
	}
}

void init3(Background& bg1, Player& p, Bullet& b, Enemy& Jahaz, Background& bg2, Enemy e[])
{
	bg1.bg.width = ScreenWidth, bg1.bg.height = ScreenHeight;
	bg2.bg.width = ScreenWidth, bg2.bg.height = ScreenHeight;
	bg1.position.r = 0, bg1.position.c = 0;
	bg2.position.r = 0, bg2.position.c = ScreenWidth;

	DrawTexture(bg1.bg, bg1.position.c, bg1.position.r, WHITE);
	DrawTexture(bg2.bg, bg2.position.c, bg2.position.r, RAYWHITE);

	initPlayer(p);

	b.texture = LoadTexture("bullet.png");

	Jahaz.ETexture = LoadTexture("plane.png");
	Jahaz.ETexture.width = 250, Jahaz.ETexture.height = 150;

	Jahaz.ColliderE.width = Jahaz.ETexture.width - 20;
	Jahaz.ColliderE.height = Jahaz.ETexture.height - 20;

	Jahaz.Eposition.r = 0, Jahaz.Eposition.c = 400;
	Jahaz.ColliderE.x = Jahaz.Eposition.c - 10;
	Jahaz.ColliderE.y = Jahaz.Eposition.r + 10;
	DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
	Jahaz.fptr = UpdatePlane;

	initEnemy(e);
}

void DrawEnemy(Enemy e[])
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		DrawTexture(e[i].ETexture, e[i].Eposition.c, e[i].Eposition.r, RAYWHITE);
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

void DelEnemy(Enemy& e, int i)
{
	e.Eposition.c = ScreenWidth + (i * 50) + 400;
	e.ColliderE.width = 0;
	e.ColliderE.height = 0;
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

void Shoot(Player &P, Bullet& b)
{
	//Leave a missile that will continue moving till end coordinates
	if (P.Direction == Right)
	{
		P.p_Texture = LoadTexture("shootright.png");
		P.p_Texture.height = 150, P.p_Texture.width = 100;
		b.texture = LoadTexture("bullet.png");
		b.texture.width = 60, b.texture.height = 40;
		b.position.c = P.c_position.c + P.p_Texture.width - 10;
		b.position.r = P.c_position.r + 30;
		b.Direction = Right;
		b.fptr = UpdateBullet;
	}
	else if (P.Direction == Left)
	{
		P.p_Texture = LoadTexture("shootleft.png");
		P.p_Texture.height = 150, P.p_Texture.width = 100;
		b.texture = LoadTexture("bulletleft.png");
		b.texture.width = 60, b.texture.height = 40;
		b.position.c = P.c_position.c - 1;
		b.position.r = P.c_position.r + 30;
		b.Direction = Left;
		b.fptr = UpdateBullet;
	}
	else if (P.Direction == Up)
	{
		P.p_Texture = LoadTexture("shootup.png");
		P.p_Texture.height = 175, P.p_Texture.width = 90;
		b.texture = LoadTexture("bulletup.png");
		b.texture.width = 40, b.texture.height = 60;
		b.position.r = P.c_position.r - 8;
		b.position.c = P.c_position.c + 20;
		b.Direction = Up;
		b.fptr = UpdateBullet;

	}
	b.C.rad = 20;
	b.C.r = b.position.r, b.C.c = b.position.c;
}

void ShootTank(Player P, Bullet& b)
{
	//Leave a missile that will continue moving till end coordinates
	if (P.Direction == Right)
	{
		b.texture = LoadTexture("bluebullet.png");
		b.texture.width = 60, b.texture.height = 40;
		b.position.c = P.c_position.c + P.p_Texture.width - 10;
		b.position.r = P.c_position.r + 30;
		b.Direction = Right;
		b.fptr = UpdateBullet;
	}
	else if (P.Direction == Left)
	{
		b.texture = LoadTexture("bluebulletLeft.png");
		b.texture.width = 60, b.texture.height = 40;
		b.position.c = P.c_position.c - 1;
		b.position.r = P.c_position.r + 30;
		b.Direction = Left;
		b.fptr = UpdateBullet;
	}
	else if (P.Direction == Up)
	{
		b.texture = LoadTexture("bluebulletUp.png");
		b.texture.width = 40, b.texture.height = 60;
		b.position.r = P.c_position.r - 8;
		b.position.c = P.c_position.c + 20;
		b.Direction = Up;
		b.fptr = UpdateBullet;

	}
	b.C.rad = 20;
	b.C.r = b.position.r, b.C.c = b.position.c;
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


void UpdateAlly1(Alley& a)
{
	a.PositionA.c -= 1;
	a.Collider.x -= 1;
}

void UpdateAlly2(Alley& a, bool& AllyGotShot)
{
	a.PositionA.c -= 10;
	a.Collider.x = a.PositionA.c;
	if (a.PositionA.c <= 0)
	{
		InitAlly(a, AllyGotShot);
	}
}

bool BulletTouchesAlley(Alley& a, Bullet b[], int size)
{
	Vector2 temp;
	for (int i = 0; i < size; i++)
	{
		temp.x = b[i].position.c;
		temp.y = b[i].position.r;

		if (CheckCollisionCircleRec(temp, (float)(b[i].C.rad), a.Collider))
		{
			return true;
		}
	}
	return false;
}

void UpdateAlly(Alley& a, Bullet b[], int size, bool& AllyGotShot, int& score)
{
	if (BulletTouchesAlley(a, b, size))  // Correct function call
	{
		a.textureA = LoadTexture("friend2.png");
		AllyGotShot = true;
		a.textureA.height = 150, a.textureA.width = 100;
		a.PositionA.r = ScreenHeight - a.textureA.height,
			a.Collider.height = a.textureA.height - 10;
		a.Collider.width = a.textureA.width - 10;
	}
	else if (a.PositionA.c <= 50)
	{
		score += 200;
		InitAlly(a, AllyGotShot);
	}

	if (AllyGotShot == true)
	{
		UpdateAlly2(a, AllyGotShot);
	}
	else
	{
		UpdateAlly1(a);
	}
}

void UpdateMissiles(Bullet Missiles[], int& size)
{
	for (int i = 0;i < size;i++)
	{
		Missiles[i].position.r += 3;
		Missiles[i].Collider.y += 3;
		DrawTexture(Missiles[i].texture, Missiles[i].position.c, Missiles[i].position.r, RAYWHITE);
		Missiles[i].fptr = UpdateMissiles;
		if (Missiles[i].position.r >= ScreenHeight)
			deleteIndex(Missiles, size, i);
	}
}

void BombardMissiles(Bullet Missiles[], int& size, Enemy Jahaz)
{
	srand(time(0));
	Missiles[size].texture = LoadTexture("missiles.png");
	Missiles[size].Direction = Down;

	Missiles[size].position.c = (rand() % (Jahaz.ETexture.width - Jahaz.Eposition.c)) + Jahaz.Eposition.c;
	Missiles[size].position.r = Jahaz.Eposition.r + Jahaz.ETexture.height;

	Missiles[size].texture.width = 50, Missiles[size].texture.height = 100;
	DrawTexture(Missiles[size].texture, Missiles[size].position.c, Missiles[size].position.r, RAYWHITE);
	Missiles[size].fptr = UpdateMissiles;

	Missiles[size].Collider.width = Missiles[size].texture.width - 20;
	Missiles[size].Collider.height = Missiles[size].texture.height - 40;
	Missiles[size].Collider.x = Missiles[size].position.c + 10;
	Missiles[size].Collider.y = Missiles[size].position.r + 10;

	size++;
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

bool PlaneDestroyed(Enemy& Jahaz, Bullet bullet[], int& size, int& count, int& score)
{
	Vector2 temp;
	for (int i = 0;i < size;i++)
	{
		temp.x = bullet[i].position.c;
		temp.y = bullet[i].position.r;

		if (CheckCollisionCircleRec(temp, (float)(bullet[i].C.rad), Jahaz.ColliderE))
		{
			count++;
			bullet[i].position.r = NULL, bullet[i].position.c = NULL;
			deleteIndex(bullet, size, i);
		}
	}
	if (count >= 100)
	{
		if (Jahaz.Eposition.c < ScreenWidth)
			Jahaz.Eposition.c += 10, Jahaz.Eposition.r += 5, DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
		return true;
	}
	return false;
}

void ReSpawnPlane(Enemy& Jahaz)
{
	Jahaz.ETexture = LoadTexture("plane.png");
	Jahaz.ETexture.width = 250, Jahaz.ETexture.height = 150;

	Jahaz.ColliderE.width = Jahaz.ETexture.width - 20;
	Jahaz.ColliderE.height = Jahaz.ETexture.height - 20;

	Jahaz.Eposition.r = 0, Jahaz.Eposition.c = 400;
	Jahaz.ColliderE.x = Jahaz.Eposition.c - 10;
	Jahaz.ColliderE.y = Jahaz.Eposition.r + 10;
	DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
	Jahaz.fptr = UpdatePlane;
}

bool MissileTouchesPlayer(Bullet Missiles[], int& size, Player p)
{
	for (int i = 0;i < size;i++)
	{
		if (CheckCollisionRecs(Missiles[i].Collider, p.Collider))
		{
			deleteIndex(Missiles, size, i);
			return true;
		}
	}
	return false;
}

void BulletTouchesEnemy(Enemy e[], Bullet b[], int& size, int& score)
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

void UpdateBomb(Bullet bomb[], int& size)
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		bomb[i].r += 0.5;
		bomb[i].c -= 2;
		bomb[i].C.r += 0.5;
		bomb[i].C.c -= 2;
		DrawTexture(bomb[i].texture, bomb[i].c, bomb[i].r, RAYWHITE);
	}
	bomb->fptr = UpdateBomb;
}

void initbomb(Enemy e[], Bullet bomb[])
{
	for (int i = 0;i < NoOfEnemies;i++)
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
	bomb->fptr = UpdateBomb;
}

void BombDestroy(Bullet bomb[], Enemy e[])
{
	for (int i = 0;i < NoOfEnemies;i++)
	{
		if (bomb[i].r >= ScreenHeight - 50)
		{
			initbomb(e, bomb);
		}
	}
}

bool BombtouchesPlayer(Player P, Bullet bomb[])
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

void initlogo(Background& logo)
{
	logo.bg = LoadTexture("MetalSluglogo.png");
	logo.bg.height = ScreenHeight;
	logo.bg.width = ScreenWidth;
	logo.position.c = 0;
	logo.position.r = 0;
}

void UpdateEnemies(Enemy e[], Enemy& Jahaz, int count)
{
	if (Jahaz.fptr == UpdatePlane)
		UpdatePlane(Jahaz, count);
	else if (Jahaz.fptr == nullptr)
		UpdatePlane2(Jahaz, count);
	for (int i = 0;i < NoOfEnemies;i++)
	{
		if (e[i].fptr == MoveEnemy)
			MoveEnemy(e[i], count);
	}
}

void UpdateCombat(Bullet bullet[], Bullet bomb[], int& size, Bullet Missiles[], int& MSize)
{
	if (bullet->fptr == UpdateBullet)
		UpdateBullet(bullet, size);
	if (bomb->fptr == UpdateBomb)
		UpdateBomb(bomb, size);
	if (Missiles->fptr == UpdateMissiles)
		UpdateMissiles(Missiles, MSize);
}

void fptrUpdatePlayer(Player& p)
{
	if (p.fptr == UpdatePlayer)
		UpdatePlayer(p);
	if (p.fptr == UpdateTank)
		UpdateTank(p);
}

void PrintLogo(Background& logo)
{
	BeginDrawing();
	ClearBackground(BLACK);
	DrawTexture(logo.bg, logo.position.c, logo.position.r, RAYWHITE);
	DrawText("CLICK ENTER TO CONTINUE.....", 225, 550, 20, RAYWHITE);
	EndDrawing();
}

void initTank(Player& p)
{
	p.p_Texture = LoadTexture("Tank.png");
	p.Direction = Right;
	p.p_Texture.height = 100, p.p_Texture.width = 150;
	p.c_position.r = ScreenHeight - p.p_Texture.height,
		p.c_position.c = 100;
	p.Collider.height = p.p_Texture.height - 10;
	p.Collider.width = p.p_Texture.width - 10;
	p.Collider.x = p.c_position.c + 5;
	p.Collider.y = p.c_position.r + 5;
	p.fptr = UpdateTank;
}

void init4(Background& bg1, Player& p, Bullet& b, Enemy& Jahaz, Background& bg2, Enemy e[])
{
	bg1.bg.width = ScreenWidth, bg1.bg.height = ScreenHeight;
	bg2.bg.width = ScreenWidth, bg2.bg.height = ScreenHeight;
	bg1.position.r = 0, bg1.position.c = 0;
	bg2.position.r = 0, bg2.position.c = ScreenWidth;

	DrawTexture(bg1.bg, bg1.position.c, bg1.position.r, WHITE);
	DrawTexture(bg2.bg, bg2.position.c, bg2.position.r, RAYWHITE);

	initTank(p);

	b.texture = LoadTexture("bullet.png");

	Jahaz.ETexture = LoadTexture("plane.png");
	Jahaz.ETexture.width = 250, Jahaz.ETexture.height = 150;

	Jahaz.ColliderE.width = Jahaz.ETexture.width - 20;
	Jahaz.ColliderE.height = Jahaz.ETexture.height - 20;

	Jahaz.Eposition.r = 0, Jahaz.Eposition.c = 400;
	Jahaz.ColliderE.x = Jahaz.Eposition.c - 10;
	Jahaz.ColliderE.y = Jahaz.Eposition.r + 10;
	DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
	Jahaz.fptr = UpdatePlane;

	initEnemy(e);
}
void InitMusic(GameSounds& m)
{

	m.Gunshots = LoadSound("Gun_shots.wav");
	//m.Helicopter = LoadSound("Helicopter.mp3");
	m.background = LoadMusicStream("Introduction_Music.mp3");
	m.End = LoadSound("EviL_Laugh.wav");
	m.Victory = LoadMusicStream("Victory.mp3");
	m.Over = LoadSound("GameOver.mp3");
	m.PlaneCrash = LoadSound("PlaneCrash.wav");
}
void CreateSounds(GameSounds& S)
{

	if (IsKeyPressed(KEY_X))
	{
		PlaySound(S.Gunshots);
	}
	if (IsKeyPressed(KEY_ESCAPE))
	{
		PlaySound(S.Over);
	}

}

void DrawLives(int& k, Background& l)
{
	while (k > 0)
	{
		DrawTexture(l.bg, l.position.c, l.position.r, RAYWHITE);
		k--, l.position.c += l.bg.width;
	}
}

int main4()
{
	SetTargetFPS(120);
	lives = 10;
	Background bg1;
	bg1.bg = LoadTexture("bg1.png");
	Background bg2, l;
	l.bg = LoadTexture("lives.png");
	l.position.r = 10, l.position.c = 120;
	l.bg.height = 40, l.bg.width = 30;
	bg2.bg = LoadTexture("bg2.png");
	Player p;
	Bullet b[Capacity]{}, bomb[NoOfEnemies]{}, Missiles[Capacity];
	Enemy e[NoOfEnemies] = { }, Jahaz;
	Alley a;
	bool AllyGotShot = false;
	InitAlly(a, AllyGotShot);
	GameSounds S;
	InitMusic(S);
	PlayMusicStream(S.background);
	PlayMusicStream(S.Victory);
	time_t CT = time(0), PRS = time(0), temptime;
	int i = 0, count = 0, Msize = 0;
	int elapsed = 0, PReSpawn = 0, temp = 0;
	init4(bg1, p, b[i], Jahaz, bg2, e);
	initbomb(e, bomb);
	Background logo;
	int k = lives;
	initlogo(logo);
	while (!IsKeyPressed(KEY_ENTER)) {
		PrintLogo(logo);
		UpdateMusicStream(S.background);
	}

	while (lives > 0)
	{
		if (GetKeyPressed() == KEY_ESCAPE)
			break;

		k = lives;
		l.position.c = 120;
		BeginDrawing();
		ClearBackground(BLACK);
		MovingBackground(bg1, bg2);
		DrawTexture(a.textureA, a.PositionA.c, a.PositionA.r, RAYWHITE);
		UpdateMusicStream(S.background);
		CreateSounds(S);
		UpdateEnemies(e, Jahaz, count);
		UpdateAlly(a, b, i, AllyGotShot, score);
		DrawEnemy(e);
		DrawLives(k, l);
		DrawText("LIVES: ", 10, 10, 30, RAYWHITE);
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
		if (PlaneDestroyed(Jahaz, b, i, count, score))
		{
			PlaySound(S.PlaneCrash);
		}
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
			initTank(p);
			initEnemy(e);
			initbomb(e, bomb);
			lives--;
		}
		fptrUpdatePlayer(p);
		UpdateCombat(b, bomb, i, Missiles, Msize);
		BulletTouchesEnemy(e, b, i, score);
		BombDestroy(bomb, e);

		if (EnemytouchesPlayer(e, p))
		{
			lives--;
			initTank(p);
			initEnemy(e);
		}
		if (MissileTouchesPlayer(Missiles, Msize, p))
		{
			lives--;
			initTank(p);
		}
		if (IsKeyDown(KEY_X))
			ShootTank(p, b[i]), i++;

		EndDrawing();
		if (score >= 10000)
			break;
	}
	if (lives == 0)
	{
		PlaySound(S.End);
	}


	if (score >= 10000)
	{
		while (!IsKeyPressed(KEY_ENTER))
		{

			if (GetKeyPressed() == KEY_ESCAPE)
			{
				break;
			}
			BeginDrawing();
			ClearBackground(BLACK);
			UpdateMusicStream(S.Victory);
			DrawText("YOU WONNNNNNNN", 70, 250, 70, RAYWHITE), CT = time(0);
			EndDrawing();
		}
	}
	else
	{
		while (true)
		{
			CreateSounds(S);
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


int main3()
{
	SetTargetFPS(120);
	//InitWindow(ScreenWidth, ScreenHeight, "Metal Slug");
	//InitAudioDevice();
	Background bg1;
	bg1.bg = LoadTexture("bg1.png");
	Background bg2, l;
	l.bg = LoadTexture("lives.png");
	l.position.r = 10, l.position.c = 120;
	l.bg.height = 40, l.bg.width = 30;
	bg2.bg = LoadTexture("bg2.png");
	Player p;
	Bullet b[Capacity]{}, bomb[NoOfEnemies]{}, Missiles[Capacity];
	Enemy e[NoOfEnemies] = { }, Jahaz;
	Alley a;
	bool AllyGotShot = false;
	InitAlly(a, AllyGotShot);
	GameSounds S;
	InitMusic(S);
	PlayMusicStream(S.background);
	PlayMusicStream(S.Victory);
	time_t CT = time(0), PRS = time(0), temptime;
	int i = 0, count = 0, Msize = 0;
	int elapsed = 0, PReSpawn = 0, temp = 0;
	init3(bg1, p, b[i], Jahaz, bg2, e);
	initbomb(e, bomb);
	int k = lives;
	Background logo;
	initlogo(logo);
	while (!IsKeyPressed(KEY_ENTER)) {
		PrintLogo(logo);
		UpdateMusicStream(S.background);
	}
	while (lives > 0)
	{
		if (GetKeyPressed() == KEY_ESCAPE)
			break;

		k = lives;
		l.position.c = 120;
		BeginDrawing();
		ClearBackground(BLACK);
		MovingBackground(bg1, bg2);
		DrawTexture(a.textureA, a.PositionA.c, a.PositionA.r, RAYWHITE);
		UpdateMusicStream(S.background);
		CreateSounds(S);
		UpdateEnemies(e, Jahaz, count);
		UpdateAlly(a, b, i, AllyGotShot, score);
		DrawEnemy(e);
		DrawText("LIVES: ", 10, 10, 30, RAYWHITE);
		DrawText(TextFormat("SCORE = %d", score), 10, 45, 30, RAYWHITE);
		DrawLives(k, l);
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
		if (PlaneDestroyed(Jahaz, b, i, count, score))
		{
			PlaySound(S.PlaneCrash);
		}
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
		fptrUpdatePlayer(p);
		UpdateCombat(b, bomb, i, Missiles, Msize);
		BulletTouchesEnemy(e, b, i, score);
		BombDestroy(bomb, e);

		if (EnemytouchesPlayer(e, p))
		{
			lives--;
			initPlayer(p);
			initEnemy(e);
		}
		if (MissileTouchesPlayer(Missiles, Msize, p))
		{
			lives--;
			initPlayer(p);
		}
		if (IsKeyDown(KEY_X))
			Shoot(p, b[i]), i++;
		EndDrawing();
		if (score >= 5000)
			break;
	}
	if (lives == 0)
	{
		PlaySound(S.End);
	}
	if (score >= 5000)
	{

		while (!IsKeyPressed(KEY_ENTER))
		{
			if (GetKeyPressed() == KEY_ESCAPE)
			{
				break;
			}
			BeginDrawing();
			ClearBackground(BLACK);
			UpdateMusicStream(S.Victory);
			DrawText("LEVEL 3 CLEARED", 70, 250, 70, RAYWHITE), CT = time(0);
			EndDrawing();
		}
		main4();
	}
	else
	{
		while (true)
		{
			CreateSounds(S);
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



void init2(Background& bg1, Player& p, Bullet& b, Enemy& Jahaz, Background& bg2)
{
	bg1.bg.width = ScreenWidth, bg1.bg.height = ScreenHeight;
	bg2.bg.width = ScreenWidth, bg2.bg.height = ScreenHeight;
	bg1.position.r = 0, bg1.position.c = 0;
	bg2.position.r = 0, bg2.position.c = ScreenWidth;

	DrawTexture(bg1.bg, bg1.position.c, bg1.position.r, WHITE);
	DrawTexture(bg2.bg, bg2.position.c, bg2.position.r, RAYWHITE);

	initPlayer(p);

	b.texture = LoadTexture("bullet.png");

	Jahaz.ETexture = LoadTexture("plane.png");
	Jahaz.ETexture.width = 250, Jahaz.ETexture.height = 150;

	Jahaz.ColliderE.width = Jahaz.ETexture.width - 20;
	Jahaz.ColliderE.height = Jahaz.ETexture.height - 20;

	Jahaz.Eposition.r = 0, Jahaz.Eposition.c = 400;
	Jahaz.ColliderE.x = Jahaz.Eposition.c - 10;
	Jahaz.ColliderE.y = Jahaz.Eposition.r + 10;
	DrawTexture(Jahaz.ETexture, Jahaz.Eposition.c, Jahaz.Eposition.r, RAYWHITE);
	Jahaz.fptr = UpdatePlane;
}

int main2()
{
	// No enemies only jahaz
	SetTargetFPS(120);
	Background bg1;
	bg1.bg = LoadTexture("bg1.png");
	Background bg2,l;
	l.bg = LoadTexture("lives.png");
	l.position.r = 10, l.position.c = 120;
	l.bg.height = 40, l.bg.width = 30;
	bg2.bg = LoadTexture("bg2.png");
	Player p;
	Bullet b[Capacity]{}, bomb[NoOfEnemies]{}, Missiles[Capacity];
	Enemy e[NoOfEnemies] = { }, Jahaz;
	GameSounds S;
	InitMusic(S);
	PlayMusicStream(S.background);
	PlayMusicStream(S.Victory);
	time_t CT = time(0), PRS = time(0), temptime;
	int i = 0, count = 0, Msize = 0;
	int elapsed = 0, PReSpawn = 0, temp = 0;
	init2(bg1, p, b[i], Jahaz, bg2);
	Background logo;
	initlogo(logo);
	while (!IsKeyPressed(KEY_ENTER)) {
		PrintLogo(logo);
		UpdateMusicStream(S.background);
	}
	int k = lives;
	while (lives > 0)
	{
		if (GetKeyPressed() == KEY_ESCAPE)
			break;

		k = lives;
		l.position.c = 120;
		BeginDrawing();
		ClearBackground(BLACK);
		MovingBackground(bg1, bg2);
		UpdateMusicStream(S.background);
		CreateSounds(S);
		UpdateEnemies(e, Jahaz, count);
		DrawLives(k, l);
		DrawText("LIVES:" , 10, 10, 30, RAYWHITE);
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
		if (PlaneDestroyed(Jahaz, b, i, count, score))
		{
			PlaySound(S.PlaneCrash);
		}
		if (count > 100 and (PReSpawn >= 20))
		{
			score += 1000;
			ReSpawnPlane(Jahaz);
			count = 0;
			PRS = time(0);
			PReSpawn = 0;
		}
		fptrUpdatePlayer(p);
		UpdateCombat(b, bomb, i, Missiles, Msize);

		if (MissileTouchesPlayer(Missiles, Msize, p))
		{
			lives--;
			initPlayer(p);
		}
		if (IsKeyDown(KEY_X))
			Shoot(p, b[i]), i++;
		EndDrawing();
		if (score >= 2500)
			break;
	}
	if (lives == 0)
	{
		PlaySound(S.End);
	}

	if (score >= 2500)
	{
		while (!IsKeyPressed(KEY_ENTER))
		{
			if (GetKeyPressed() == KEY_ESCAPE)
			{
				break;
			}
			BeginDrawing();
			ClearBackground(BLACK);
			UpdateMusicStream(S.Victory);
			DrawText("LEVEL 2 CLEARED", 75, 250, 70, RAYWHITE), CT = time(0);
			EndDrawing();
		}
		main3();
	}
	else
	{
		while (true)
		{
			CreateSounds(S);
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

void init1(Background& bg1, Player& p, Bullet& b, Background& bg2, Enemy e[])
{
	bg1.bg.width = ScreenWidth, bg1.bg.height = ScreenHeight;
	bg2.bg.width = ScreenWidth, bg2.bg.height = ScreenHeight;
	bg1.position.r = 0, bg1.position.c = 0;
	bg2.position.r = 0, bg2.position.c = ScreenWidth;

	DrawTexture(bg1.bg, bg1.position.c, bg1.position.r, WHITE);
	DrawTexture(bg2.bg, bg2.position.c, bg2.position.r, RAYWHITE);

	initPlayer(p);

	b.texture = LoadTexture("bullet.png");

	initEnemy(e);
}

int main()
{
	SetTargetFPS(120);
	InitWindow(ScreenWidth, ScreenHeight, "Metal Slug");
	InitAudioDevice();
	Background bg1;
	bg1.bg = LoadTexture("bg1.png");
	Background bg2, l;
	l.bg = LoadTexture("lives.png");
	l.position.r = 10, l.position.c = 120;
	l.bg.height = 40, l.bg.width = 30;
	bg2.bg = LoadTexture("bg2.png");
	Player p;
	Bullet b[Capacity]{}, bomb[NoOfEnemies]{}, Missiles[Capacity];
	Enemy e[NoOfEnemies] = { }, Jahaz;
	GameSounds S;
	InitMusic(S);
	PlayMusicStream(S.background);
	PlayMusicStream(S.Victory);
	time_t CT = time(0), PRS = time(0), temptime;
	int i = 0, count = 0, Msize = 0;
	int elapsed = 0, PReSpawn = 0, temp = 0;
	init1(bg1, p, b[i], bg2, e);
	initbomb(e, bomb);
	Background logo;
	initlogo(logo);
	while (!IsKeyPressed(KEY_ENTER)) {
		PrintLogo(logo);
		UpdateMusicStream(S.background);
	}
	int k = lives;
	while (lives > 0)
	{
		if (GetKeyPressed() == KEY_ESCAPE)
			break;
		k = lives;
		l.position.c = 120;
		BeginDrawing();
		ClearBackground(BLACK);
		MovingBackground(bg1, bg2);
		UpdateMusicStream(S.background);
		CreateSounds(S);
		UpdateEnemies(e, Jahaz, count);
		DrawEnemy(e);
		DrawLives(k, l);
		DrawText("LIVES: ", 10, 10, 30, RAYWHITE);
		DrawText(TextFormat("SCORE = %d", score), 10, 45, 30, RAYWHITE);

		DrawTexture(p.p_Texture, p.c_position.c, p.c_position.r, RAYWHITE);

		time_t NT = time(0);
		elapsed = NT - CT;

		if (BombtouchesPlayer(p, bomb))
		{
			initPlayer(p);
			initEnemy(e);
			initbomb(e, bomb);
			lives--;
		}
		fptrUpdatePlayer(p);
		UpdateCombat(b, bomb, i, Missiles, Msize);
		BulletTouchesEnemy(e, b, i, score);
		BombDestroy(bomb, e);

		if (EnemytouchesPlayer(e, p))
		{
			lives--;
			initPlayer(p);
			initEnemy(e);
		}
		if (IsKeyDown(KEY_X))
			Shoot(p, b[i]), i++;
		EndDrawing();
		if (score >= 1000)
			break;
	}
	if (lives == 0)
	{
		PlaySound(S.End);
	}

	if (score >= 1000)
	{
		while (!IsKeyPressed(KEY_ENTER))
		{
			if (GetKeyPressed() == KEY_ESCAPE)
			{
				break;
			}
			BeginDrawing();
			ClearBackground(BLACK);
			UpdateMusicStream(S.Victory);
			DrawText("LEVEL 1 CLEARED", 80, 250, 75, RAYWHITE), CT = time(0);
			EndDrawing();

		}
		main2();
	}
	else
	{
		while (true)
		{
			CreateSounds(S);
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
