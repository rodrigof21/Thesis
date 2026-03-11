
#### Workflow do projeto:

1. Plot do bode diagram para vários valores de nu e zeta
	1. [[find_fo_bode4.m]]
	2. Conclusões tiradas
2. Desenvolvimento da função da inversa de Fourier para calcular a resposta ao degrau unitário
	1. validar a função [[testing_with_known_systems.m]]
	2. comparar com fomcon toolbox
	3. [[fotf_test.m]]
	4. [[invFourierTrapz.m]]
3. Provar que $\omega_n$ é um fator de escala no tempo
	1. Provar de que forma influencia a escala
	2. [[coeffVsParams.m]]
	3. [[Effects of varying wn]]
	4. [[varyingWn.m]]
	5. [[Analytical proof of the effects of wn]]
4. Verifcar gráfico de estabilidade
	1. [[stabilityChart.m]]
5.  Base de dados com várias respostas no tempo 
	1. filtrar resultados estáveis
	2. [[filterUnstablePairs.m]]
	3. [[UnitStepResponse.m]]
	4. [[createImagesFromDatabase.m]]
6. Escolher pontos de interesse em [[Points to analyze]]
7. extrair os pontos
	1. [[extractPointsFromDatabase.m]]
	2. Mp, t02, t05, t08
8. validar os pontos 1 a 1
	1. [[validatePoints.m]]
9. plot da comparação dos pontos
	1. [[comparePoints.m]]
	2. [[surfaceMapping.m]]
10. (Opcional) Identificador Automático
	1. [[idModel_test.m]]
	2. [[identify_system.m]]
	3. [[identificationTest.m]]
11. Modelo de Identificação "analítico"
	1. [[curveFit_test.m]]
	2. 
