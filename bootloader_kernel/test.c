void main()
{
	char *video = (char*)0xb8400;
	char text[] = "WELCOME TO VOSx";
	int i, j = 0;
	for(i = 0; text[i] != '\0'; i++)
	{
		*video = text[i];
		video += 2;
	}
}
