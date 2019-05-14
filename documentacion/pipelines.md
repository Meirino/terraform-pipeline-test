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

También podemos seleccionar la instalación que queremos usar con el Snippet Generator:

![Alt](./imgs/IMG11.png "IMG11")

Y, en vez de instalar las herramientas, podemos pedir a Jenkins que las instale por nosotros al usarlas:

![Alt](./imgs/IMG12.png "IMG12")

## Jenkinsfile

```
pipeline{
    agent{
        label "node"
    }
    stages{
        stage("A"){
            steps{
                echo "========executing A========"
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}
```