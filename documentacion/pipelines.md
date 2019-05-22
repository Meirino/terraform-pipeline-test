## Crear Pipeline

Para crear una pipeline nueva, vamos a “Nueva tarea” en el menú principal y seleccionamos “Pipeline” e introducimos el nombre.

![Alt](./imgs/IMG1.png "IMG1")

Luego pasaremos a la propia pantalla de configuración donde podemos activar varias opciones.

![Alt](./imgs/IMG2.png "IMG2")

Lo más importante es la propia pipeline. Se puede usar un script dentro de Jenkins, o vincular la pipeline a un Jenkinsfile (El archivo con la pipeline) remoto en un repositorio de Git.

![Alt](./imgs/IMG3.png "IMG3")
![Alt](./imgs/IMG4.png "IMG4")

## Configurar credenciales

Para configurar credenciales de acceso necesitamos insertarlas en Jenkins para evitar exponerlas en un repositorio remoto que podría no ser seguro.

En particular, para insertar las credenciales de AWS, primero es necesario instalar el plugin de “CloudBees AWS Credentials Plugin”.

Posteriormente vamos a “Pipeline Syntax > Snippet Generator” y seleccionamos “With credentials: Bind credentials to variables”. Y en “Bindings” añadimos “AWS Access key and secret”.

![Alt](./imgs/IMG5.png "IMG5")

Posteriormente seleccionamos el símbolo de “Add” para añadir credenciales nuevas.

![Alt](./imgs/IMG6.png "IMG6")

Tras añadir las credenciales, seleccionamos las credenciales y le damos a “Generate Pipeline Script” y se creará un bloque de texto.

Dentro de este bloque, se podrán usar las variables de `AWS_ACCESS_KEY_ID` y `AWS_SECRET_ACCESS_KEY` para que el propio Jenkins las sustituya por los valores almacenados internamente con el valor `credentialsId`.

![Alt](./imgs/IMG7.png "IMG7")

El siguiente paso para configurar una pipeline de Jenkins es instalar las herramientas necesarias en el sistema. En este caso, Terraform, Packer y Node.

![Alt](./imgs/IMG8.png "IMG8")

Después es necesario instalar los plugins correspondientes y configurar el path de instalación en Jenkins en “Configurar Jenkins > Global Tool Configuration”.

![Alt](./imgs/IMG9.png "IMG9")
![Alt](./imgs/IMG10.png "IMG10")

Y, en vez de instalar las herramientas, podemos pedir a Jenkins que las instale por nosotros al usarlas:

![Alt](./imgs/IMG12.png "IMG12")

## Jenkinsfile

```
env.foo = bar

pipeline {
    agent { docker { image 'python:3.5.1' } }
    stages {
        stage('build') {
            steps {
                sh 'python --version'
            }
        }
    }
}
```

En este template de pipeline podemos ver que un Jenkinsfile básico se compone de:

### Variables

Nombradas como `env.foo = bar` de forma que se pueden usar en el propio jenkinsfile.

### Pipeline

Es el bloque principal donde se definen los pasos a realizar.

#### Agent

Los agentes de Jenkins definen entornos de ejecución donde se realizarán los pasos establecidos.
Por ejemplo:

```
agent {
    docker { image 'node:7-alpine' }
    }
```

Este agente indica que todo el pipeline se ejecutará dentro de un contenedor cine esa imagen base.

- `agent any` usará cualquier agente disponible.
- `agent none` forzará a que cada bloque Stage tenga su propio agente definido dentro.
- `agent { label 'my-defined-label' }` usará el agente definido con la tag correspondiente.
- `agent { node { label 'labelName' } }` se comporta igual que `agent { label 'labelName' }` pero permite usar la etiqueta `customWorkspace` para designar un directorio de trabajo.

Ejemplo:

```
agent {
    node {
        label 'my-defined-label'
        customWorkspace '/some/other/path'
    }
}
```

#### Stages

Este bloque contiene las distitintas etapas del pipeline.
Dentro de cada bloque `Stage`, pueden estar declarados:

- `Steps`, un bloque con una colección de comandos que se ejecutarán.
- Agente específico de ese bloque.
- Condiciones de post-procesado.

Un ejemplo de bloque `Stage` podría ser:

```
stage('build') {
    agent { docker { image 'python:3.5.1' } }
    steps {
        sh 'python my-file.py'
    }
}
```

### Tools

Este bloque define la instalación de la herramienta que queremos usar. Estas instalaciones son las anteriormente definidas en la configuración global de las herramientas: Manage Jenkins → Global Tool Configuration.

```
tools {
    terraform 'terraform_remote_install_linux'
}
```

Referenciaría esta instalación:

![Alt](./imgs/IMG12.png "IMG12")

Por lo que Jenkins descagaría el binario dentro de una carpeta temporal propia, y lo usaría para todos los comandos de la pipeline.

### Input

Va dentro de un bloque `Stage` y obliga a que el usuario de el visto bueno, o de lo contrario no se ejecutarán las siguientes etapas.
Requiere un mensaje de texto, y se puede personalizar el texto del botón de ok.

```
input {
    message "Should we continue?"
    ok "Yes, we should."
}
```

### Parallel

Permite ejecutar varios `Stages` en paralelo.
La opción `failFast` a `true` permite que, cuando falle una rama, se detengan las demás.

```
stage('Parallel Stage') {
    failFast true
    parallel {
        stage('Branch A') {
            agent {
                ...ss
            }
            steps {
                echo "On Branch A"
            }
        }
        stage('Branch B') {
            agent {
                ...
            }
            steps {
                echo "On Branch B"
            }
        }
        stage('Branch C') {
            agent {
                ...
            }
            stages {
                stage('Nested 1') {
                    steps {
                        echo "In stage Nested 1 within Branch C"
                    }
                }
                stage('Nested 2') {
                    steps {
                        echo "In stage Nested 2 within Branch C"
                    }
                }
            }
        }
    }
```

# Blue Ocean

Blue Ocean es un conjunto de plugins que añade una vista mucho más amigable y minimalista a Jenkins.

Cuando entramos a través del menú principal de Jenkins, aparecerán todas las pipelines y jobs disponibles.

![Alt](./imgs/IMG13.png "Blue Ocean menú pincipal")

Desde ahí podemos crear una nueva pipeline.

## Crear una pipeline

Al entrar en el menú de creación de pipeline, veremos un selector de repositorio de Git.

![Alt](./imgs/IMG14.png "Creación de pipeline en Blue Ocean, 1")

Podremos seleccionar varios orígenes, ya sea Github o BitBucket, o desde un origen genérico mediante SSH o HTTP.

![Alt](./imgs/IMG15.png "Creación de pipeline en Blue Ocean, 2")

En este caso, desde un origen HTTP, introducimos la URL y añadimos las credenciales del repositorio. Acto seguido seleccionamos **Create Credentials** y después, **Create pipeline**.

Si el repositorio está vacío, o no tiene un Jenkinsfile, Jenkis nos ayudará a crear uno.

![Alt](./imgs/IMG16.png "Creación de Jenkinsfile en Blue Ocean, 1")

La interfaz de Blue Ocean nos guiará por los pasos de creación.

![Alt](./imgs/IMG17.png "Creación de Jenkinsfile en Blue Ocean, 2")

En este ejemplo se ha creado una pipeline muy simple, que obtiene los archivos de Git y valida los archivos de Packer.

![Alt](./imgs/IMG18.png "Creación de Jenkinsfile en Blue Ocean, 3")
![Alt](./imgs/IMG19.png "Creación de Jenkinsfile en Blue Ocean, 4")
![Alt](./imgs/IMG20.png "Creación de Jenkinsfile en Blue Ocean, 5")

Una vez creado, Jenkins nos hará hacer un commit al repositorio con el Jenkinsfile creado.

![Alt](./imgs/IMG21.png "Creación de Jenkinsfile en Blue Ocean, 6")

## Ejecutando una pipeline

Al configurar el Jenkinsfile y ejecutar el pipeline con éxito, se obtendrá algo parecido a esto.
Podemos hacer click en cada nodo para ver la salida por consola de cada comando ejecutado dentro de cada stage.

![Alt](./imgs/IMG22.png "Ejecución de una pipeline en Blue Ocean, 1")
![Alt](./imgs/IMG23.png "Ejecución de una pipeline en Blue Ocean, 2")

En el menú principal de la pipeline, podemos ver el historial de ejecuciones.

![Alt](./imgs/IMG25.png "Ejecución de una pipeline en Blue Ocean, 4")

Dentro del menu de cada ejecución, podemos editar la pipeline.

![Alt](./imgs/IMG24.png "Ejecución de una pipeline en Blue Ocean, 3")

## Añadir una rama

Tras crear una rama usando los comandos de Git (`git checkout -b <nombre>`), se debe ir al menú "clásico" de Jenkins y escanear nuevas ramas.

![Alt](./imgs/IMG26.png "Añadiendo una rama en Blue Ocean, 1")
![Alt](./imgs/IMG27.png "Añadiendo una rama en Blue Ocean, 2")
![Alt](./imgs/IMG28.png "Añadiendo una rama en Blue Ocean, 3")

## Flujo de trabajo

Para trabajar con ramas se puede trabajar de distintas maneras:

- Crear una rama por cada cuenta o zona de trabajo (Producción, Pre-Producción, Management, Shared), etc... y trabajar sobre ellas de forma independiente. La rama `master` tendría una mezcla de todas las ramas una vez se alcanze un punto clave en el proyecto.

Por otra parte, para trabajar con las pipelines de Jenkins, se puede trabjar de estas formas:

- Crear una pipeline y modificarla según la rama en la que se trabaje, esencialmente teniendo un Jenkinsfile distinto por cada rama.
- Crear una pipeline única y usar scripts de Groovy, y variables de entorno, para controlar el flujo de las distintas ramas.

![Alt](https://dzone.com/storage/temp/10940867-8-ci-cd-using-hashicorp-terraform-and-jenkins.png "Flujo de trabajo 1")
![Alt](https://labouardy.com/images/packer-1.png "Flujo de trabajo 2")
![Alt](https://cdn-images-1.medium.com/max/2400/1*AkUv8y2S4lzSz4QkxUImgg.png "Flujo de trabajo 3")
![Alt](https://user-images.githubusercontent.com/52489/30888694-d07d68c8-a2d6-11e7-90b2-d8275ef94f39.png "Flujo de trabajo 4")

# Documentación

- [Herramientas de desarollo](https://jenkins.io/doc/book/pipeline/development/)
- [Sintaxis](https://jenkins.io/doc/book/pipeline/syntax/)
- [Blue Ocean](https://jenkins.io/doc/book/blueocean/)
