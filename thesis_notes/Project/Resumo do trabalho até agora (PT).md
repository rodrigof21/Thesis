
#### Workflow do projeto:

1. Plot do bode diagram para varios valores de nu e zeta
	1. [[find_fo_bode4.m]]
	2. Conclusoes tiradas
2. Desenvolvimento da funçao da inversa de fourier para calcular a resposta ao degrau unitário
	1. validar a funcao [[testing_with_known_systems.m]]
	2. [[invFourierTrapz.m]]
3. (TODO) Provar que $\omega_n$ é um fator de escala no tempo
	1. Provar de que forma influencia a escala
	2. [[Effects of varying wn]]
	3. [[varyingWn.m]]
	4. [[Analytical proof of the effects of wn]]
4. Verifcar gráfico de estabilidade
	1. [[stabilityChart.m]]
	2. 
5.  Base de dados com várias respostas no tempo 
	1. filtrar resultados estáveis
	2. comparar com fotf toolbox
	3. [[fotf_test.m]]
	4. [[filterUnstablePairs.m]]
	5. [[UnitStepResponse.m]]
	6. [[createImagesFromDatabase.m]]
6. Escolher pontos de interesse em [[Points to analyze]]
7. extrair os pontos
	1. [[extractPoints.m]]
8. validar os pontos 1 a 1
	1. [[validatePoints.m]]
9. plot da comparaçao dos pontos
	1. [[comparePoints.m]]
10. retirar outliers manualmente